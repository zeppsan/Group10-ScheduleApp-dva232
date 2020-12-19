import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:schedule_dva232/injection_container.dart' as ic;
import 'package:schedule_dva232/map/presentation/browsing_ploc/browsing_logic.dart';
import 'package:schedule_dva232/map/presentation/widgets/browsing_plan_display.dart';
import 'package:schedule_dva232/map/presentation/widgets/widgets.dart';
import 'package:schedule_dva232/generalPages/settings.dart';

class BrowsingPage extends StatelessWidget {
  final String buildingToFind;
  const BrowsingPage({Key key,  this.buildingToFind}):super(key:key);

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
  String roomToFind;

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
