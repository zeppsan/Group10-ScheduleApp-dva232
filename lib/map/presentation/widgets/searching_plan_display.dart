import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_dva232/map/data_domain/models/room.dart';
import 'package:schedule_dva232/map/data_domain/usecases/get_room_list_usecase.dart';
import 'package:schedule_dva232/map/presentation/searching_ploc/searching_logic.dart';
import 'package:schedule_dva232/schedule/thisweek.dart';
import '../../locationAnimation.dart';
import 'package:schedule_dva232/injection_container.dart' as ic;

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

 List<String> roomNames;
 String roomToFind;
 AutoCompleteTextField searchTextField;
 GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

 void loadList() async {
   var getRoomList = ic.serviceLocator.get<GetRoomList>();
   roomNames = await getRoomList();
   setState((){});
 }

 @override
 void initState() {
    setState(() {
      _showPosition=(widget.room.floor==_currentFloor );
      _isShowPathButton = _showPath? false: true;
    });
    loadList();
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
          roomNames == null ? CircularProgressIndicator() :
          searchTextField = AutoCompleteTextField<String>(
            key: key,
            clearOnSubmit: false,
            submitOnSuggestionTap: true,
            suggestions: roomNames,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  roomToFind = searchTextField.controller.text.toString();
                  dispatchGetRoom(roomToFind);
                },
                icon: Icon(Icons.search_rounded),
                color: lightTheme ? const Color(0xff2c1d33) : const Color(
                    0xffeeb462),),
              contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              hintText: widget.room.name,
              hintStyle: TextStyle(fontWeight: FontWeight.bold,
                  color: lightTheme ? const Color(0xff2c1d33) : const Color(0xffeeb462)
              ),
            ),
            itemFilter: (item, query) {
              return item.toLowerCase().startsWith(query.toLowerCase());
            },
            itemSorter: (a, b) {
              return a.compareTo(b);
            },
            itemSubmitted: (item) {
              setState(() {
                searchTextField.textField.controller.text = item;
                roomToFind = item;
              });
              dispatchGetRoom(roomToFind);
            },
            itemBuilder: (context, item) {
              return row(item);
            },
          ),
         /* TextFormField(
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
          ),*/

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
                color: lightTheme? const Color(0xff2c1d33) : Theme.of(context).accentColor,
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
                  color: lightTheme? const Color(0xff2c1d33) : Theme.of(context).accentColor,
                  onPressed: () { Next(); },
                ),
              )
            ]
          ),
        ]
      )
    );
  }

 Widget row(String room) {
   return Container(
     padding: EdgeInsets.all(15.0),
     decoration: BoxDecoration(
       border: Border(
           bottom: BorderSide(color: Colors.grey.withOpacity(0.3))),
     ),
     child: Row(
       children: [
         Container(
           child: Text(room, style: TextStyle(
               fontSize: 20.0,
               color: lightTheme ? const Color(0xff2c1d33) : const Color(
                   0xffeeb462))),
         ),
       ],
     ),
   );
 }

 void dispatchGetRoom(String roomToFind) {
   BlocProvider.of<SearchingLogic>(context)
       .add(GetRoomEvent(roomToFind));
 }

 void dispatchGetPlanEvent(int _currentFloor, Room room) {
   BlocProvider.of<SearchingLogic>(context)
       .add(GetPlanEvent(_currentFloor, room));
 }
}



