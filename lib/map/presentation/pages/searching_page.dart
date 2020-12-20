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
import 'package:schedule_dva232/map/presentation/widgets/Search_bar_widget.dart';
import 'package:schedule_dva232/map/presentation/widgets/searching_plan_display.dart';
import 'package:schedule_dva232/map/presentation/widgets/widgets.dart';
import 'package:schedule_dva232/map/locationAnimation.dart';
import 'package:schedule_dva232/generalPages/settings.dart';
import 'package:schedule_dva232/schedule/thisweek.dart';
//import 'package:schedule_dva232/map/data_domain/models/roomNames.dart';

class SearchingPage extends StatelessWidget {
  final String roomToFind;
  const SearchingPage({Key key,  this.roomToFind}):super(key:key);

  @override build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
      appBar: AppBar(
        title: Text('Map'),
        actions: [
          Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.more_vert_outlined),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              }
          ),
        ],
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
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
                                  RichText(
                                    text: TextSpan(
                                      style: new TextStyle(
                                        fontSize: 14.0,
                                        color: lightTheme? Colors.black : Colors.white,
                                      ),
                                      children: <TextSpan>[
                                        new TextSpan(text: 'Show '),
                                        new TextSpan(text: state.room.name, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                                        new TextSpan(text: ' on floor plan'),
                                      ],
                                    )
                                  ),

                               //Text('Show $roomToFind on floor plan'),
                                  Icon(Icons.arrow_forward_rounded,
                                    color: lightTheme? const Color(0xff2c1d33) : Theme.of(context).accentColor,
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

