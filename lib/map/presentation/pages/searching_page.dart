import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:schedule_dva232/map/data_domain/models/room.dart';
import 'package:schedule_dva232/injection_container.dart' as ic;
import 'package:schedule_dva232/map/presentation/searching_ploc/searching_logic.dart';
import 'package:schedule_dva232/map/presentation/widgets/plan_display.dart';
import 'package:schedule_dva232/map/presentation/widgets/widgets.dart';

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
              Flexible(
                flex: 2,
                child: TopControlsWidgetForSearching(inputString:roomToFind),
              ),
              Flexible(
                flex: 7,
                child: //TODO: change to appropriate widget
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
                            child: new Column (
                              children: <Widget> [
                                Flexible (
                                  flex:4,
                                  child: BasicMapWidget(basicMapToShow: state.room.building.name),
                                ),
                                Flexible(
                                  flex:1,
                                  child: RaisedButton(
                                    child: Text('To the floor plans'),
                                    color: Theme
                                        .of(context)
                                        .accentColor,
                                    textTheme: ButtonTextTheme.primary,
                                    onPressed: () { dispatchGetFloorPlan(context, state.room, state.room.floor); },
                                  ),
                                ),
                              ],
                            ),
                        );
                      } else if (state is PlanLoaded) {
                        print('in builder state is PlanLoaded');
                        return WillPopScope(
                            onWillPop: () async { print('something');  dispatchGetRoom(context, state.room.name); return false;},
                            child: PlanDisplay( null, state.currentFloor, state.room),
                        );
                      } else {
                        return MessageDisplay(message: 'Unexpected error');
                      }
                    }
                ),
              ),
            ]
            //TODO:Common bottomWidget?
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
          TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter a room',
          ),
          controller: txt,
          onChanged: (value) { roomToFind = value; }
        ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: Text('Search'),
                    color: Theme
                      .of(context)
                      .accentColor,
                    textTheme: ButtonTextTheme.primary,
                    onPressed: () {dispatchGetRoom(roomToFind);},
                ),
              ),
              Expanded(
                child: RaisedButton(
                  child: Text('Buildings U & T'),
                  color: Theme
                      .of(context)
                      .accentColor,
                  textTheme: ButtonTextTheme.primary,
                  onPressed: () { Navigator.of(context).pushNamed('/browsing', arguments: 'U');}
                ),
              ),
              Expanded(
                child: RaisedButton(
                  child: Text('Building R'),
                  color: Theme
                      .of(context)
                      .accentColor,
                  textTheme: ButtonTextTheme.primary,
                  onPressed: () { Navigator.of(context).pushNamed('/browsing', arguments: 'R');}
                ),
              ),
            ],
          ),
        ],
      );
    }

    void dispatchGetRoom(String roomToFind) {
    BlocProvider.of<SearchingLogic>(context)
        .add(GetRoomEvent(roomToFind));
  }
}
