
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:schedule_dva232/map/data_domain/models/room.dart';

class PlanDisplay extends StatefulWidget{
  int _currentFloor;
  final Building building;
  final Room room;
  PlanDisplay(this.building,this._currentFloor, this.room);

  @override
  _PlanDisplayState createState() => _PlanDisplayState(_currentFloor);
}

class _PlanDisplayState extends State<PlanDisplay> {
 int _currentFloor;
 bool showCoordinates;
 _PlanDisplayState(this._currentFloor);

 @override
 void initState() {
    setState(() {
      showCoordinates=(widget.room!=null);
    });
 }

 void Next() {
   setState(() {
     if (widget.room==null && _currentFloor < widget.building.floors || _currentFloor <widget.room.building.floors)
       _currentFloor++;
     if (widget.room!=null)
     showCoordinates= _currentFloor!= widget.room.floor ? false : true;
   });
 }

 void Previous() {
   setState(() {
     if (_currentFloor > 1)
       _currentFloor--;
     if (widget.room!=null)
     showCoordinates= _currentFloor != widget.room.floor ? false : true;
   });
 }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: [
          Flexible (
            flex: 4,
           // child: MapBuildingWidget(building: widget.building !=null ? widget.building : widget.room.building, room: widget.room, floor:_currentFloor, showCoordinates: showCoordinates),
          ),
          Flexible (
            flex:1,
            child: Text(widget.building != null ? widget.building.name: widget.room.building.name,
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),),
        Flexible (
          flex:1,
          child:Row(
              children: <Widget> [
                Expanded(
                  child: RaisedButton(
                    child: Text('Previous floor'),
                    color: Theme
                        .of(context)
                        .accentColor,
                    textTheme: ButtonTextTheme.primary,
                    onPressed: () { Previous(); },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Text('floorplan for floor: $_currentFloor ',
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    child: Text('Next floor'),
                    color: Theme
                        .of(context)
                        .accentColor,
                    textTheme: ButtonTextTheme.primary,
                    onPressed: () { Next();  },
                  ),
                ),

            ]
          ),
        )
        ],
      ),
    ); //Container
  }
}



