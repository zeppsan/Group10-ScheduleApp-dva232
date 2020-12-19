import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:schedule_dva232/injection_container.dart' as ic;
import 'package:schedule_dva232/map/data_domain/usecases/get_room_list_usecase.dart';
import 'package:schedule_dva232/map/presentation/browsing_ploc/browsing_logic.dart';
import 'package:schedule_dva232/map/presentation/widgets/browsing_plan_display.dart';
import 'package:schedule_dva232/map/presentation/widgets/widgets.dart';
import 'package:schedule_dva232/generalPages/settings.dart';
import 'package:schedule_dva232/schedule/thisweek.dart';
import 'package:sizer/sizer.dart';

class BrowsingPage extends StatelessWidget {
  final String buildingToFind;
  const BrowsingPage({Key key,  this.buildingToFind}):super(key:key);

  @override build(BuildContext context) {
    return LayoutBuilder(
      builder:(context,constraints) {
        return OrientationBuilder(
            builder: (context, orientation) {
              SizerUtil().init(constraints, orientation);
              return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: Text('Map'),
                ),
                endDrawer: Settings(),
                body: buildBody(context),
                bottomNavigationBar: NavigationBarLoggedIn(),
              );
            }
        );
      }
    );
  }

  Widget buildBody(BuildContext context) {
    return BlocProvider(
      create: (context)=> ic.serviceLocator<BrowsingLogic>(),
      child: Center(
        //TODO: change to appropriate widget
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
                TopControlsWidgetForBrowsing(),

                Expanded(
                  child: BlocBuilder<BrowsingLogic, BrowsingState>(
                      builder: (context,state) {
                        if (state is EmptyState) {
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(child: BasicMapWidget(basicMapToShow: 'basic')),
                              Visibility(
                                visible:false,
                                maintainState: true,
                                maintainAnimation:true,
                                maintainSize:true,
                                child: FlatButton (
                                  child: Row (
                                    children: [
                                      Text('To floor plans'),
                                      Icon(Icons.arrow_forward_rounded)
                                    ]
                                  ),
                                ),
                              )
                            ],
                          );

                        } else if (state is LoadingState) {
                          return LoadingWidget();
                        } else if (state is ErrorState) {
                          return MessageDisplay(message: state.message);
                        } else if (state is BuildingLoadedState) {
                          return WillPopScope(
                            onWillPop: () async { dispatchGetOriginal(context); return false;},
                            child: Column (
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded (child: BasicMapWidget(basicMapToShow: state.building.name)),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: FlatButton(
                                      child:Row (
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text('To floor plans'),
                                            Icon(Icons.arrow_forward_rounded,
                                              color: lightTheme? const Color(0xff2c1d33) : Theme.of(context).accentColor,
                                            ),
                                          ]
                                      ),
                                      onPressed: () { dispatchGetFloorPlan(context, state.building, 1); },

                                  ),
                                )
                              ],
                            ),
                          );
                        } else if (state is PlanLoaded) {
                          return WillPopScope(
                            onWillPop: () async { dispatchGetBuilding(context, state.building); return false;},
                            child: BrowsingPlanDisplay( state.building));
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
  void dispatchGetFloorPlan(BuildContext context, Building building, int floorToShow)
  {
    BlocProvider.of<BrowsingLogic>(context)
        .add(GetPlanEvent(1, building));
  }
  void dispatchGetBuilding(BuildContext context, Building building)
  {
    BlocProvider.of<BrowsingLogic>(context)
        .add(GetBuildingEvent(building.name));
  }
  void dispatchGetOriginal(BuildContext context)
  {
    BlocProvider.of<BrowsingLogic>(context)
        .add(GetOriginalEvent());
  }

}

class TopControlsWidgetForBrowsing extends StatefulWidget {

  const TopControlsWidgetForBrowsing({ Key key}): super(key: key);

  @override
  _TopControlsWidgetForBrowsingState createState() => _TopControlsWidgetForBrowsingState();
}

class _TopControlsWidgetForBrowsingState extends State<TopControlsWidgetForBrowsing> {
  List<String> roomNames;
  String roomToFind;
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  //_TopControlsWidgetForSearchingState({this.roomToFind});

  void loadList() async {
    var getRoomList = ic.serviceLocator.get<GetRoomList>();
    roomNames = await getRoomList();
    setState((){});
  }

  @override
  void initState() {
    loadList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              onPressed: (){
                roomToFind = searchTextField.controller.text.toString();
                Navigator.of(context).pushNamed('/searching', arguments: roomToFind);
               // dispatchGetRoom(roomToFind);
              },
              icon: Icon(Icons.search_rounded),
              color: lightTheme? const Color(0xff2c1d33) : const Color(0xffeeb462),),
            //contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
            hintText:  "Search room",
            hintStyle: TextStyle(fontWeight: FontWeight.bold, color: lightTheme? const Color(0xff2c1d33) : const Color(0xffeeb462)),
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
              Navigator.of(context).pushNamed('/searching', arguments: roomToFind);
            });
            //dispatchGetRoom(roomToFind);
          },
          itemBuilder: (context, item) {
            return row(item);
          },
        ),
        SizedBox(height: 10),

        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: Text('Buildings U & T',
                    style: TextStyle (
                      fontSize: 12.0.sp,
                    )),
                onPressed: () {
                  dispatchGetBuilding('U');
                },
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: ElevatedButton(
                child: Text('Building R',style: TextStyle (
                  fontSize: 12.0.sp,
                )),
                onPressed: () {
                  dispatchGetBuilding('R');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget row(String room) {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.3))),
      ),
      child: Row(
        children: [
          Container(
            child: Text(room, style: TextStyle(
                fontSize: 20.0,
                color: lightTheme? const Color(0xff2c1d33) : const Color(0xffeeb462))),
          ),
        ],
      ),
    );
  }
  /*String roomToFind;

    @override
    Widget build(BuildContext context) {
      return Column(
        children: <Widget>[
          TextFormField(
            onChanged: (value) {
              roomToFind = value;
            },
            onFieldSubmitted: (value){
              roomToFind = value;
              Navigator.of(context).pushNamed('/searching', arguments: roomToFind);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),),
              hintText: "Search room",

             suffixIcon: IconButton(
               onPressed: (){
                 Navigator.of(context).pushNamed('/searching', arguments: roomToFind);
               },

               icon: Icon(Icons.search_rounded),
               //size: 34.0,
             ),
              ),
            ),

          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  child: Text('Buildings U & T',
                  style: TextStyle (
                    fontSize: 12.0.sp,
                  )),
                  onPressed: () {
                    dispatchGetBuilding('U');
                  },
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: ElevatedButton(
                  child: Text('Building R',style: TextStyle (
                    fontSize: 12.0.sp,
                  )),
                  onPressed: () {
                    dispatchGetBuilding('R');
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }

    void dispatchGetBuilding(String buildingToFind) {
    BlocProvider.of<BrowsingLogic>(context)
        .add(GetBuildingEvent(buildingToFind));
  }*/

  void dispatchGetBuilding(String buildingToFind) {
    BlocProvider.of<BrowsingLogic>(context)
        .add(GetBuildingEvent(buildingToFind));
  }
}
