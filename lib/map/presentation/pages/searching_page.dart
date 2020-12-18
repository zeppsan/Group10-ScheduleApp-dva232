import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:schedule_dva232/map/data_domain/models/room.dart';
import 'package:schedule_dva232/injection_container.dart' as ic;
import 'package:schedule_dva232/map/presentation/searching_ploc/searching_logic.dart';
import 'package:schedule_dva232/map/presentation/widgets/searching_plan_display.dart';
import 'package:schedule_dva232/map/presentation/widgets/widgets.dart';

//TODO: Should probably be Stateful
class SearchingPage extends StatelessWidget {
  final String roomToFind;
  const SearchingPage({Key key,  this.roomToFind}):super(key:key);

  @override build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
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
                      return Container(
                        child: Column  (
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget> [
                            Expanded(child: BasicMapWidget(basicMapToShow: state.room.building.name)),
                            FlatButton(
                              child:Row (
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
                          ],
                        ),
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
  String roomToFind;

  _TopControlsWidgetForSearchingState({this.roomToFind});

    @override
    Widget build(BuildContext context) {
      var txt=TextEditingController();
      txt.text=roomToFind;

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
