import 'package:flutter/material.dart';
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
  String roomToFind;
  _TopControlsWidgetForSearchingState({this.roomToFind});
    @override
    Widget build(BuildContext context) {
      var txt=TextEditingController();
      txt.text=roomToFind;
      print('building TopControlsWidget');
      return Column(
        children: <Widget>[
          TextFormField(
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
          Row(),
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
}
