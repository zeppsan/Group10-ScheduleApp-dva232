
import 'dart:convert';
import 'package:schedule_dva232/globalNotification.dart' as global;
import 'package:badges/badges.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_dva232/schedule/subfiles/CourseParser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'noteClass.dart';



class NotificationList extends StatefulWidget {
  OverlayEntry overlayEntry;
  final double appBarSize;
  final bool hasData;
  

  NotificationList({this.appBarSize, this.hasData});

  @override
  _NotificationList createState() => _NotificationList();
}

class _NotificationList extends State<NotificationList>{
  bool dropDownOpen = false;
  bool lightTheme;
  bool loggedIn;
  double containerHeight = 0.0;
  Map<DateTime, List<Lecture>> rawScheduleList;


  @override
  void initState() {
    //getScheduleUpdates();
    super.initState();
  }

  void openDropDown(){

    widget.overlayEntry = overlayEntryBuilder();
    Overlay.of(context).insert(widget.overlayEntry);
    setState(() {
      dropDownOpen = true;
    });
  }

  void closeDropDown(){

    setState(() {
      dropDownOpen = false;
    });
    widget.overlayEntry.remove();

  }

  void manegeDropDown(){
    if (dropDownOpen) {
      print('closing dropdown');
      closeDropDown();
      dropDownOpen = false;
    }
    else {
      print('open dropdown');
      openDropDown();
      dropDownOpen = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getVariableValue(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.done:
             // rawScheduleList = snapshot.data;
              //createNotes();
              if(global.notificationList != null && global.numberOfItems > 0)
                return Badge(
                  badgeContent: Text(global.numberOfItems.toString()),
                  toAnimate: false,
                  animationType: BadgeAnimationType.scale,
                  position: BadgePosition.topEnd(end: 5, top: 5),
                  child: IconButton(
                    icon: Icon(Icons.notifications_rounded),
                    onPressed: () {
                      manegeDropDown();
                    },
                  ),
                );

              else
                return IconButton(
                  icon: Icon(Icons.notifications_rounded),
                  onPressed: () {
                    manegeDropDown();
                  },
                );
              break;

            default:
              return IconButton(
                icon: Icon(Icons.notifications_rounded),
                onPressed: () {
                  manegeDropDown();
                },
              );
          }
        });
  }


  OverlayEntry overlayEntryBuilder() {
    return OverlayEntry(
        builder: (context){
          return Positioned(
            top: widget.appBarSize,

            child: Stack(
              children: [
                GestureDetector(
                  onTap:  () {
                    closeDropDown();
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                ),
                if(global.notificationList != null && global.numberOfItems > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 22.0),
                    child: GestureDetector(

                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.6,

                        decoration: BoxDecoration(
                          color: (lightTheme) ? const Color(0xffeeb462) : const Color(0xff2c1d33),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0) ),

                        ),

                        child: ListView.builder(
                          itemCount: global.notificationList.length,
                          itemBuilder: (BuildContext context, int index){
                            if(global.notificationList[index].show)
                            return Card(
                              color: const Color(0xffeeb462),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  ListTile(

                                    title: Text(global.notificationList[index].title),
                                    subtitle: Text('${global.notificationList[index].date} ${global.notificationList[index].courseCode}\n'
                                        '${global.notificationList[index].content}'),
                                    trailing: IconButton(
                                      onPressed: () {
                                        global.notificationList[index].show = false;
                                        global.numberOfItems--;
                                        closeDropDown();
                                        openDropDown();
                                      },
                                        icon: Icon(Icons.check)
                                    ),
                                  )
                                ],
                              ),
                            );
                            else
                              return Container();
                          },
                        ),
                      ),
                    ),
                  )
                else
                  Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(top:22.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.2,

                        decoration: BoxDecoration(
                          color: (lightTheme)? const Color(0xffeeb462) : const Color(0xff2c1d33),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0) ),

                        ),

                        child: Center(
                          child: Text(
                            loggedIn ? 'There are no new notifications' : 'Login to see notifications',
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color(0xffeeb462),
                            ),

                          ),
                        ),
                      ),
                    ),
                  ),
              ],

              //child: Material (
              //color: Colors.transparent,

              //),
            ),

          );
        }
    );
  }

 /* Future<Map<DateTime, List<Lecture>>> parseSchedule(context) async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    CourseParser parser = CourseParser(rawData: jsonDecode(localStorage.getString('rawSchedule')));
    await parser.parseRawData();
    return parser.events;
  }*/

  Future getVariableValue() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    lightTheme = localStorage.getBool('theme');
    loggedIn = localStorage.getBool('loggedIn');
  }
  
 /* void createNotes() {
    Note newNote;
    //notificationList = List<Note>();

    rawScheduleList.forEach((key, value) {
      String title, content, courseCode, date, id;
      date = '${key.day}/${key.month}';

      value.forEach((element) {
        title = 'Schedule change';
        content = element.moment;
        courseCode = element.course_code.toUpperCase();
        id = title + date + courseCode;

        newNote = Note(title: title, content: content, courseCode: courseCode, date: date, id: id);
        
        var exists = global.notificationList.firstWhere((element) => element.id == newNote.id, orElse: () => null); //check if item already exists
        if(exists == null)
          {
            global.notificationList.add(newNote);
            global.numberOfItems++;
          }
      });
    });
  }*/
}