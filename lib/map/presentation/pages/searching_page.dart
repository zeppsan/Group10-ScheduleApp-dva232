import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:schedule_dva232/appComponents/topMenu.dart';
import 'package:schedule_dva232/map/data_domain/models/room.dart';
import 'package:schedule_dva232/injection_container.dart' as ic;
import 'package:schedule_dva232/map/presentation/searching_ploc/searching_logic.dart';
import 'package:schedule_dva232/map/presentation/widgets/searching_plan_display.dart';
import 'package:schedule_dva232/map/presentation/widgets/widgets.dart';
import 'package:schedule_dva232/generalPages/settings.dart';
import 'package:schedule_dva232/notification/notifications.dart';
import 'package:schedule_dva232/schedule/thisweek.dart';

class SearchingPage extends StatelessWidget {
  final String roomToFind;
  final Room room;
  const SearchingPage({Key key,  this.roomToFind, this.room}):super(key:key);

  // Base
  @override build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
      appBar: AppBar(
        centerTitle: false,
        title: Text('Map',style: TextStyle(fontFamily: "Roboto")),
        actions: [
          NotificationPage(appBarSize: AppBar().preferredSize.height),

          TopMenu()
        ],
      ),
      endDrawer: Settings(),
      body: buildBody(context),
      bottomNavigationBar: NavigationBarLoggedIn(),
    );
  }

  // Body
  Widget buildBody(BuildContext context) {
    return BlocProvider(
      create: (context)=> ic.serviceLocator<SearchingLogic>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: BlocConsumer<SearchingLogic, SearchingState>(
                  listener: (context,state) {
                    if ( state is ErrorState) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return MessageDisplay(message: state.message);
                        }
                      );
                    }
                  }, // listener
                  // Don't build when state is error state
                  buildWhen: (previous,current) { return current is !ErrorState;},
                  builder: (context, state) {
                    if (state is EmptyState) {
                      BlocProvider.of<SearchingLogic>(context).add(GetRoomEvent(roomToFind));
                      return Container();
                    } else if (state is LoadingState) {
                      return LoadingWidget();
                    } else if (state is RoomLoadedState) {
                      return Column  (
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget> [
                          SearchBarWidget(mode:'searching', roomToFind:state.room.name),
                          SizedBox(height: 50,),
                          Expanded(child: BasicMapWidget(basicMapToShow: state.room.building.name)),
                          Align(
                            alignment:Alignment.centerRight,
                            child: FlatButton(
                              child:Row (
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: new TextStyle(
                                        fontSize: 14.0,
                                        color: Theme.of(context).scaffoldBackgroundColor == Colors.white ? Colors.black : Colors.white,
                                      ),
                                      children: <TextSpan>[
                                        new TextSpan(text: 'Show '),
                                        new TextSpan(text: state.room.name, style: new TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold, fontSize: 16.0)),
                                        new TextSpan(text: ' on floor plan'),
                                      ],
                                    )
                                  ),
                                  Icon(Icons.arrow_forward_rounded,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ]
                              ),
                              onPressed: () { dispatchGetPlanEvent(context, state.room.floor, state.room ); },
                            ),
                          ),
                        ],
                      );
                    } else if (state is PlanLoaded) {
                      return Column  (
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget> [
                          Expanded(
                            child: WillPopScope(
                              onWillPop: () async { dispatchGetKnownRoom(context, state.room); return false;},
                              child: SearchingPlanDisplay(state.room.floor, state.room),
                           )
                          ),
                        ]
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

  void dispatchGetPlanEvent(BuildContext context, int _currentFloor, Room room) {
    BlocProvider.of<SearchingLogic>(context)
        .add(GetPlanEvent(_currentFloor, room));
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

