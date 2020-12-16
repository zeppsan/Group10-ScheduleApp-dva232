
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:schedule_dva232/map/data_domain/models/room.dart';
import 'package:schedule_dva232/map/presentation/widgets/basic_map_widget.dart';

class BrowsingPlanDisplay extends StatefulWidget{
  //int _currentFloor = 1;
  final Building building;

  BrowsingPlanDisplay(this.building);

  @override
  _BrowsingPlanDisplayState createState() => _BrowsingPlanDisplayState();
}

class _BrowsingPlanDisplayState extends State<BrowsingPlanDisplay> {
 int _currentFloor=1;
 String buildingFloor;

 _BrowsingPlanDisplayState() {
   print(_currentFloor);
   _currentFloor = 1;

 }
 @override
 void initState(){
   setState(() {
     buildingFloor = widget.building.name + _currentFloor.toString();
     //buildingFloor = 'R1';
     print(buildingFloor);
   });
 }
 void Next() {
   setState(() {
     if (_currentFloor < widget.building.floors) {
       _currentFloor++;
       buildingFloor = widget.building.name + _currentFloor.toString();
     }
   }
   );
 }

 void Previous() {
   setState(() {
     if (_currentFloor > 1)
     {
       _currentFloor--;
       buildingFloor = widget.building.name + _currentFloor.toString();
     }

   });
 }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: [
          BasicMapWidget(basicMapToShow: buildingFloor),
        Row(
            children: <Widget> [
              IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                color: Theme
                    .of(context)
                    .accentColor,
                onPressed: () { Previous(); },
              ),
              Expanded(child: SizedBox()),
              IconButton(
                icon: Icon(Icons.arrow_forward_rounded),
                color: Theme
                    .of(context)
                    .accentColor,
                onPressed: () { Next(); },
              ),

          ]
        )
        ],
      ),
    ); //Container
  }
}



