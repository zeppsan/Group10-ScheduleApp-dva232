import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:schedule_dva232/appComponents/topMenu.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:schedule_dva232/injection_container.dart' as ic;
import 'package:schedule_dva232/map/presentation/browsing_ploc/browsing_logic.dart';
import 'package:schedule_dva232/map/presentation/widgets/browsing_plan_display.dart';
import 'package:schedule_dva232/map/presentation/widgets/widgets.dart';
import 'package:schedule_dva232/generalPages/settings.dart';
import 'package:schedule_dva232/notification/notifications.dart';
import 'package:schedule_dva232/schedule/thisweek.dart';

class BrowsingPage extends StatelessWidget {
  final String buildingToFind;
  const BrowsingPage({Key key,  this.buildingToFind}):super(key:key);

  // Base
  @override build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        title: Text('Map',style: TextStyle(fontFamily: "Roboto")),
        actions: [
          NotificationPage(appBarSize: AppBar().preferredSize.height),
          TopMenu(),
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
      create: (context)=> ic.serviceLocator<BrowsingLogic>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TopControlsWidgetForBrowsing(), // Search bar and building buttons

              Expanded(
                child: BlocConsumer<BrowsingLogic,BrowsingState>(
                  listener: (context, state) {
                    if(state is ErrorState) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:(_) {
                          return MessageDisplay(message: state.message);
                        }
                      );
                    } else if (state is RoomFoundState) {
                        Navigator.of(context).pushNamed(
                          '/searching', arguments: state.room.name);
                    }
                  }, // listener
                  // Do not build if state is ErrorState or RoomFoundState
                  buildWhen: (previous,current) {return current is !ErrorState && current is !RoomFoundState;},
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
                              onPressed: () {  },
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
                                      color: Theme.of(context).accentColor,
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
                  } // builder
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

// Searchbar, bulding buttons
class TopControlsWidgetForBrowsing extends StatefulWidget {

  const TopControlsWidgetForBrowsing({ Key key}): super(key: key);

  @override
  _TopControlsWidgetForBrowsingState createState() => _TopControlsWidgetForBrowsingState();
}

class _TopControlsWidgetForBrowsingState extends State<TopControlsWidgetForBrowsing> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SearchBarWidget(mode:'browsing'),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: Text('Buildings U & T'),
                onPressed: () {
                  dispatchGetBuilding('U');
                },
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: ElevatedButton(
                child: Text('Building R'),
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
  }
}
