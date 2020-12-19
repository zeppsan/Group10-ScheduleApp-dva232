import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:schedule_dva232/map/data_domain/models/room.dart';
import 'package:schedule_dva232/injection_container.dart' as ic;
import 'package:schedule_dva232/map/data_domain/repositories/room_repository.dart';
import 'package:schedule_dva232/map/data_domain/usecases/get_room_list_usecase.dart';
import 'package:schedule_dva232/map/presentation/searching_ploc/searching_logic.dart';
import 'package:schedule_dva232/map/presentation/widgets/searching_plan_display.dart';
import 'package:schedule_dva232/map/presentation/widgets/widgets.dart';
import 'package:schedule_dva232/map/locationAnimation.dart';
import 'package:schedule_dva232/generalPages/settings.dart';
//import 'package:schedule_dva232/map/data_domain/models/roomNames.dart';

class SearchingPage extends StatelessWidget {
  final String roomToFind;
  const SearchingPage({Key key,  this.roomToFind}):super(key:key);

  @override build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
      appBar: AppBar(
        title: Text('Map'),
      ),
      endDrawer: Settings(),
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
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TopControlsWidgetForSearching(inputString:roomToFind),

              Expanded(
                child: BlocBuilder<SearchingLogic, SearchingState>(
                  builder: (context,state) {
                    if (state is EmptyState) {
                      BlocProvider.of<SearchingLogic>(context).add(GetRoomEvent(roomToFind));
                      return Container();
                    } else if (state is LoadingState) {
                      return LoadingWidget();
                    } else if (state is ErrorState) {
                      return MessageDisplay(message: state.message);
                    } else if (state is RoomLoadedState) {
                      return Column  (
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget> [
                          Expanded(child: BasicMapWidget(basicMapToShow: state.room.building.name)),
                          Align(
                            alignment:Alignment.centerRight,
                            child: FlatButton(
                              child:Row (
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('Show on the floor plan'),
                                  Icon(Icons.arrow_forward_rounded,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ]
                              ),
                              onPressed: () { dispatchGetFloorPlan(context, state.room, state.room.floor); },
                            ),
                          ),
                        ],
                      );
                    } else if (state is PlanLoaded) {
                      return WillPopScope(
                          onWillPop: () async { dispatchGetKnownRoom(context, state.room); return false;},
                          child: SearchingPlanDisplay(state.room.floor, state.room),
                      );
                    } else {
                      return MessageDisplay(message: 'Unexpected error');
                    }
                  }
                ),
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
  void dispatchGetKnownRoom(BuildContext context, Room room)
  {
    BlocProvider.of<SearchingLogic>(context)
        .add(GetKnownRoomEvent(room));
  }

}

class TopControlsWidgetForSearching extends StatefulWidget {
  String inputString;

  TopControlsWidgetForSearching({ Key key, this.inputString}): super(key: key);

  @override
  _TopControlsWidgetForSearchingState createState() => _TopControlsWidgetForSearchingState(roomToFind:inputString);
}

class _TopControlsWidgetForSearchingState extends State<TopControlsWidgetForSearching> {
  List<String> roomNames;
  String roomToFind;
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  _TopControlsWidgetForSearchingState({this.roomToFind});

  void loadList() async {
    print('kor func');
    var getRoomList = ic.serviceLocator.get<GetRoomList>();
    roomNames = await getRoomList();
    print(roomNames);
    setState((){});
  }

  @override
  void initState() {
    loadList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print (roomNames);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          roomNames==null
              ? CircularProgressIndicator()
              : searchTextField = AutoCompleteTextField<String>(
            key: key,
            clearOnSubmit: false,
            submitOnSuggestionTap: true,
            suggestions: roomNames,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),),
              suffixIcon: IconButton(
              onPressed: (){
                roomToFind = searchTextField.controller.text.toString();
                dispatchGetRoom(roomToFind);
              },
              icon: Icon(Icons.search_rounded),),
              contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
              hintText:  "Search room",
              hintStyle: TextStyle(color: const Color(0xffeeb462)),
              ),
            itemFilter: (item, query) {
              return item.toLowerCase().startsWith(query.toLowerCase());
            },
            itemSorter: (a, b) {
              return a.compareTo(b);
            },
            itemSubmitted: (item) {
              setState(() {
                searchTextField.textField.controller.text = item;
                roomToFind = item;
              });
              dispatchGetRoom(roomToFind);
            },
            itemBuilder: (context, item) {
              return row(item);
            },
          ),
          SizedBox(height: 10),
        ],
      );
  }

  Widget row(String room) {
    return Card(
        color: const Color(0xffeeb462),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(room, style: TextStyle(fontSize: 20.0)),
              Padding(padding: EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 5.0),),
            ]
        )
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
}

