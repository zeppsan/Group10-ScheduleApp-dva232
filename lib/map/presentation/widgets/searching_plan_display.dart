
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_dva232/map/data_domain/models/building.dart';
import 'package:schedule_dva232/map/data_domain/models/room.dart';

import '../../locationAnimation.dart';

class SearchingPlanDisplay extends StatefulWidget{
  int _currentFloor;
  final Room room;
  SearchingPlanDisplay(this._currentFloor, this.room);

  @override
  _SearchingPlanDisplayState createState() => _SearchingPlanDisplayState(_currentFloor);
}

class _SearchingPlanDisplayState extends State<SearchingPlanDisplay> {
 int _currentFloor;
 bool _showPosition;
 bool showPath = false;
 _SearchingPlanDisplayState(this._currentFloor);

 @override
 void initState() {
    setState(() {
      _showPosition=(widget.room!=null);
    });
 }

 void Next() {
   setState(() {
     if (widget.room==null && _currentFloor <widget.room.building.floors)
       _currentFloor++;
     if (widget.room!=null)
       _showPosition= _currentFloor!= widget.room.floor ? false : true;
   });
 }

 void Previous() {
   setState(() {
     if (_currentFloor > 1)
       _currentFloor--;
     if (widget.room!=null)
       _showPosition = _currentFloor != widget.room.floor ? false : true;
   });
 }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: [
          LocationAnimation(room: widget.room, showPosition: _showPosition, showPath: showPath ),
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
        ),
      ]
    )
  );
    //Container
  }
}



