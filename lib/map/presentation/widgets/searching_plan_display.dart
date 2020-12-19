import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_dva232/map/data_domain/models/room.dart';
import 'package:schedule_dva232/map/presentation/searching_ploc/searching_logic.dart';
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
 bool _showPath = false;
 bool _isShowPathButton=true;
 _SearchingPlanDisplayState(this._currentFloor);

 @override
 void initState() {
    setState(() {
      _showPosition=(widget.room.floor==_currentFloor );
      _isShowPathButton = _showPath? false: true;
    });
 }

 void Next() {
   setState(() {
     if (_currentFloor <widget.room.building.floors)
       _currentFloor++;
     _showPosition= _currentFloor!= widget.room.floor ? false : true;
     _showPath = _currentFloor== widget.room.floor && !_isShowPathButton ? true : false;
   });
 }

 void Previous() {
   setState(() {
     if (_currentFloor > 1)
       _currentFloor--;
     else
       BlocProvider.of<SearchingLogic>(context).add(GetKnownRoomEvent(widget.room));
     _showPosition = _currentFloor != widget.room.floor ? false : true;
     _showPath = _currentFloor== widget.room.floor && !_isShowPathButton ? true : false;
   });
 }

 void ShowPath(){
   setState(() {
     _isShowPathButton=false;
     _showPath = true;
   });
 }

 void HidePath(){
   setState(() {
     _isShowPathButton=true;
     _showPath=false;
   });
 }
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            maintainState: true,
            maintainSize: true,
            maintainAnimation: true,
            visible: (_currentFloor == widget.room.floor),
            child: Row (
              children: [
                Expanded (
                  child:ElevatedButton(
                    onPressed: () {_isShowPathButton ? ShowPath():HidePath();},
                    child: Text(_isShowPathButton? 'Show path' : 'Hide path',
                    ),
                  ),
                )
              ]
            ),
          ),
          Expanded(child: LocationAnimation(room: widget.room, showPosition: _showPosition, showPath: _showPath, currentFloor: _currentFloor )),
          Row(
            children: <Widget> [
              IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                color: Theme.of(context).accentColor,
                onPressed: () { Previous(); },
              ),
              Expanded(child: SizedBox()),
              Visibility (
                visible: _currentFloor!=widget.room.building.floors,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_rounded),
                  color: Theme.of(context).accentColor,
                  onPressed: () { Next(); },
                ),
              )
            ]
          ),
        ]
      )
    );
  }
}



