import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:schedule_dva232/injection_container.dart' as ic;
import 'package:schedule_dva232/map/presentation/browsing_ploc/browsing_logic.dart';
import 'package:schedule_dva232/map/presentation/widgets/browsing_plan_display.dart';
import 'package:schedule_dva232/map/presentation/widgets/widgets.dart';

//TODO: Should probably be Stateful
class BrowsingPage extends StatelessWidget {
  final String buildingToFind;
  const BrowsingPage({Key key,  this.buildingToFind}):super(key:key);

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
      create: (context)=> ic.serviceLocator<BrowsingLogic>(),
      child: Center(
        //TODO: change to appropriate widget
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: TopControlsWidgetForBrowsing(),
              ),
              Flexible(
                flex: 7,
                child: //TODO: change to appropriate widget
                BlocBuilder<BrowsingLogic, BrowsingState>(
                    builder: (context,state) {
                      if (state is EmptyState) {
                        return BasicMapWidget(basicMapToShow: 'basic');
                        //BlocProvider.of<BrowsingLogic>(context).add(GetBuildingEvent(buildingToFind));
                        //return Container();
                      } else if (state is LoadingState) {
                        return LoadingWidget();
                      } else if (state is ErrorState) {
                        return MessageDisplay(message: state.message);
                      } else if (state is BuildingLoadedState) {
                        return Container(
                            child: Stack (
                                children: <Widget>[
                                  BasicMapWidget(basicMapToShow: state.building.name),
                                  Positioned(
                                    top: 10,
                                    left: 20,
                                    child: ElevatedButton(
                                      child: Text('To floor plans'),
                                      onPressed: () { dispatchGetFloorPlan(context, state.building, 1); },
                                    ),
                                  ),
                                  ],
                                ),
                        );
                      } else if (state is PlanLoaded) {
                        return WillPopScope(
                          onWillPop: () async { print('something');  dispatchGetBuilding(context, state.building); return false;},
                          child: PlanDisplay( state.building));
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
  void dispatchGetFloorPlan(BuildContext context, Building building, int floorToShow)
  {
    print('before event fires: ' + building.name);
    BlocProvider.of<BrowsingLogic>(context)
        .add(GetPlanEvent(1, building));
  }
  void dispatchGetBuilding(BuildContext context, Building building)
  {
    print (building.name);
    BlocProvider.of<BrowsingLogic>(context)
        .add(GetBuildingEvent(building.name));
  }

}


//TODO: Change accordingly to UI design
// TODO:This should probably be Stateless. Probably create another file.
//TODO: How to combine with the same for intro and searching (ontap actions are different)
class TopControlsWidgetForBrowsing extends StatefulWidget {

  const TopControlsWidgetForBrowsing({ Key key}): super(key: key);

  @override
  _TopControlsWidgetForBrowsingState createState() => _TopControlsWidgetForBrowsingState();
}

class _TopControlsWidgetForBrowsingState extends State<TopControlsWidgetForBrowsing> {
  String roomToFind;

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
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
        ),
      );
    }

    void dispatchGetBuilding(String buildingToFind) {
    BlocProvider.of<BrowsingLogic>(context)
        .add(GetBuildingEvent(buildingToFind));
  }
}
