import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:schedule_dva232/map/presentation/browsing_ploc/browsing_logic.dart';
import 'package:schedule_dva232/map/presentation/widgets/basic_map_widget.dart';
import 'package:schedule_dva232/schedule/thisweek.dart';

// Widget to present building floorplans with navigation arrows in browsing mode
class BrowsingPlanDisplay extends StatefulWidget{
  final Building building;
  BrowsingPlanDisplay(this.building);

  @override
  _BrowsingPlanDisplayState createState() => _BrowsingPlanDisplayState();
}

class _BrowsingPlanDisplayState extends State<BrowsingPlanDisplay> {
 int _currentFloor=1;
 String buildingFloor;

 _BrowsingPlanDisplayState() {
   _currentFloor = 1;
 }

 @override
 void initState(){
   setState(() {
     buildingFloor = widget.building.name + _currentFloor.toString();
   });
 }

 void Next() {
   setState(() {
     if (_currentFloor < widget.building.floors) {
       _currentFloor++;
       buildingFloor = widget.building.name + _currentFloor.toString();
     }
   });
 }

 void Previous() {
   setState(() {
     if (_currentFloor > 1) {
       _currentFloor--;
       buildingFloor = widget.building.name + _currentFloor.toString();
     }
     else
       BlocProvider.of<BrowsingLogic>(context).add(GetKnownBuildingEvent(widget.building));
   });
 }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded (child: BasicMapWidget(basicMapToShow: buildingFloor)),
          Row(
            children: <Widget> [
              IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                color: lightTheme? const Color(0xff2c1d33) : Theme.of(context).accentColor,
                onPressed: () { Previous(); },
              ),
              Expanded(child: SizedBox()),
              Visibility (
                visible: _currentFloor!=widget.building.floors,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_rounded),
                  color: lightTheme? const Color(0xff2c1d33) : Theme.of(context).accentColor,
                  onPressed: () { Next(); },
                ),
              )
            ]
          )
        ],
      ),
    );
  }
}



