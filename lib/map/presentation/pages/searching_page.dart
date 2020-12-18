import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:schedule_dva232/map/data_domain/models/room.dart';
import 'package:schedule_dva232/injection_container.dart' as ic;
import 'package:schedule_dva232/map/presentation/searching_ploc/searching_logic.dart';
import 'package:schedule_dva232/map/presentation/widgets/browsing_plan_display.dart';
import 'package:schedule_dva232/map/presentation/widgets/searching_plan_display.dart';
import 'package:schedule_dva232/map/presentation/widgets/widgets.dart';
import 'package:schedule_dva232/map/locationAnimation.dart';
import 'package:schedule_dva232/map/data_domain/models/roomNames.dart';

//TODO: Should probably be Stateful
class SearchingPage extends StatelessWidget {
  final String roomToFind;
  const SearchingPage({Key key,  this.roomToFind}):super(key:key);

  @override build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
      //TODO: Is there common AppBar to Share?
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: buildBody(context),
      bottomNavigationBar: NavigationBarLoggedIn(),
    );
  }

  Widget buildBody(BuildContext context) {
    return BlocProvider(
      create: (context)=> ic.serviceLocator<SearchingLogic>(),
      child: Center(
        //TODO: change to appropriate widget
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TopControlsWidgetForSearching(inputString:roomToFind),

              BlocBuilder<SearchingLogic, SearchingState>(
                builder: (context,state) {
                  if (state is EmptyState) {
                    print('in builder state is Empty. Searching for ' + roomToFind);
                    BlocProvider.of<SearchingLogic>(context).add(GetRoomEvent(roomToFind));
                    return Container();
                  } else if (state is LoadingState) {
                    print('in builder state is Loading');
                    return LoadingWidget();
                  } else if (state is ErrorState) {
                    print('in builder state is Error');
                    return MessageDisplay(message: state.message);
                  } else if (state is RoomLoadedState) {
                    print('in builder state is Loaded');
                    return Container(
                      child: Column  (
                          children: <Widget> [
                            ElevatedButton(
                                child: Text('Show room on the floor plan'),
                                onPressed: () { dispatchGetFloorPlan(context, state.room, state.room.floor); },
                              ),

                            BasicMapWidget(basicMapToShow: state.room.building.name),

                          ],
                        ),
                    );
                  } else if (state is PlanLoaded) {
                    print('in builder state is PlanLoaded');
                    return WillPopScope(
                        onWillPop: () async { print('something');  dispatchGetRoom(context, state.room.name); return false;},
                        child: SearchingPlanDisplay(state.room.floor, state.room),
                    );
                  } else {
                    return MessageDisplay(message: 'Unexpected error');
                  }
                }
              ),
            ]
          ),
        )
      ),
    );
  }
  void dispatchGetFloorPlan(BuildContext context, Room room, int floorToShow)
  {
    BlocProvider.of<SearchingLogic>(context)
        .add(GetPlanEvent(floorToShow,room ));
  }
  void dispatchGetRoom(BuildContext context, String roomToFind)
  {
    BlocProvider.of<SearchingLogic>(context)
        .add(GetRoomEvent(roomToFind));
  }
}


//TODO: Change accordingly to UI design
// TODO:This should probably be Stateless. Probably create another file.
//TODO: How to combine with the same for intro and searching (ontap actions are different)
class TopControlsWidgetForSearching extends StatefulWidget {
  String inputString;

  TopControlsWidgetForSearching({ Key key, this.inputString}): super(key: key);

  @override
  _TopControlsWidgetForSearchingState createState() => _TopControlsWidgetForSearchingState(roomToFind:inputString);
}

class _TopControlsWidgetForSearchingState extends State<TopControlsWidgetForSearching> {

  final FocusNode _focusNode = FocusNode();

  OverlayEntry _overlayEntry;

  GlobalKey<AutoCompleteTextFieldState<RoomNames>> key = new GlobalKey();
  String roomToFind;

  AutoCompleteTextField searchTextField;

  static List<RoomNames> roomList = new List<RoomNames>();

  String roomSuggestion;


  void getRoomList ()  async {
    final String buildings = await rootBundle.loadString("assets/rooms.json");
    Map<String, dynamic> jsonBuildings = json.decode(buildings);
    for (Map<String, dynamic> room in jsonBuildings['rooms']) {

            roomList.add(new RoomNames.fromJson(room));
          }
          print(roomList[0].name);
        }


  @override
  void initState() {
    getRoomList();
    _focusNode.addListener(() {
      if(_focusNode.hasFocus) {
        roomSuggestion = searchTextField.controller.text.toString();
        //test = "room found";
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
      }
      else {
        this._overlayEntry.remove();
      }
    });
  }

  OverlayEntry _createOverlayEntry () {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
          left: offset.dx,
          top: offset.dy + size.height + 5.0,
          //width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,
          child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, item) {
                    return
                          ListTile(
                          title: Text(roomSuggestion, style: TextStyle(fontSize: 16.0)),
                    );
                  },
                ),
            ),
       // )
    );
  }

  _TopControlsWidgetForSearchingState({this.roomToFind});
    @override
    Widget build(BuildContext context) {
      //var txt=TextEditingController();
      //txt.text=roomToFind;
      print('building TopControlsWidget');
      return Column(
        children: <Widget>[
          searchTextField = AutoCompleteTextField<RoomNames>(
          focusNode: this._focusNode,
          key: key,
          clearOnSubmit: false,
          suggestions: roomList,
          textInputAction: TextInputAction.done,
          style: TextStyle(color: Colors.black, fontSize: 16.0),
          submitOnSuggestionTap: true,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: (){
                roomToFind = searchTextField.controller.text.toString();
                dispatchGetRoom(roomToFind);
              },
              icon: Icon(Icons.search_rounded),),
            contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
            hintText:  "Search room",
            hintStyle: TextStyle(color: Colors.black),
          ),
            itemFilter: (item, query){
            return item.name.toLowerCase().startsWith(query.toLowerCase());
            },
            itemSorter: (a, b){
            return a.name.compareTo(b.name);
            },
            itemSubmitted: (item){
              setState(() {
                searchTextField.textField.controller.text = item.name;
                roomToFind = item.name;
                dispatchGetRoom(roomToFind);
              });
            },
            itemBuilder: (context, item) {
            return row(item);
            },
      ),
          /*TextFormField(
            controller: txt,
            onChanged: (value) {
              roomToFind = value;
            },
            onFieldSubmitted: (value){
              roomToFind = value;
              dispatchGetRoom(roomToFind);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),),
              hintText: "Search room",

              suffixIcon: IconButton(
                onPressed: (){ dispatchGetRoom(roomToFind);
                },
                icon: Icon(Icons.search_rounded),
                //size: 34.0,
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(),*/
        ],
      );
    }

    void dispatchGetRoom(String roomToFind) {
    BlocProvider.of<SearchingLogic>(context)
        .add(GetRoomEvent(roomToFind));
  }

  void dispatchGetPlanEvent(int _currentFloor, Room room) {
    BlocProvider.of<SearchingLogic>(context)
        .add(GetPlanEvent(_currentFloor, room));
  }

  Widget row(RoomNames room) {
      return Card(
          color: const Color(0xffeeb462),
    child: Column(
        mainAxisSize: MainAxisSize.min,
      children: [
        Text(room.name, style: TextStyle(fontSize: 20.0)),
        Padding(padding: EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 5.0),),
      ]
      )
      );
  }
}
