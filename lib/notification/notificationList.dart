
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
  bool lightTheme = true;
  bool loggedIn = false;
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
              if(loggedIn && global.notificationList != null && global.numberOfItems > 0)
                return Badge(
                  badgeContent: Text(global.numberOfItems.toString()),
                  badgeColor: Colors.red[900],
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 22.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                ),

                //if logged in, there are items in list, and number of "active" notifications are at least one
                //build the list of notification cards

                if(loggedIn && global.notificationList != null && global.numberOfItems > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 22.0),
                    child: Container(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                        maxWidth: MediaQuery.of(context).size.width,
                        minHeight: MediaQuery.of(context).size.height * 0.15,
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),

                      decoration: BoxDecoration(
                        color: (lightTheme) ? const Color(0xffeeb462) : const Color(0xff2c1d33),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0) ),

                      ),

                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: global.notificationList.length,
                        itemBuilder: (BuildContext context, int index){
                          if(global.notificationList[index].show)
                          return Card(
                            color: (lightTheme) ? const Color(0xff2c1d33) : const Color(0xffeeb462),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max ,
                              children: [

                                ListTile(

                                  title: Text(
                                    '${global.notificationList[index].date.day}/${global.notificationList[index].date.month} '
                                        '${global.notificationList[index].title}',
                                    style: TextStyle(
                                      color: (lightTheme) ? Colors.white : const Color(0xff2c1d33),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                      '${global.notificationList[index].content} \n ${global.notificationList[index].noteText}',
                                      style: TextStyle(
                                      color: (lightTheme) ? Colors.white  : const Color(0xff2c1d33),
                          ),),

                                  trailing: IconButton(
                                    onPressed: () {
                                      global.notificationList[index].show = false;
                                      global.numberOfItems--;
                                      closeDropDown();
                                      openDropDown();
                                    },
                                      icon: Icon(
                                        Icons.check,
                                        color: (lightTheme) ? Colors.white  : const Color(0xff2c1d33),
                                      )
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
                  )

                  //if not logged in or there are no notification yet
                //build this widget witch only contains a text-field
                else
                  Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(top:22.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.15,

                        decoration: BoxDecoration(
                          color: (lightTheme)? const Color(0xffeeb462) : const Color(0xff2c1d33),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5.0), bottomRight: Radius.circular(5.0) ),

                        ),

                        child: Center(
                          child: Text(
                            loggedIn ? 'There are no new notifications' : 'Login to see notifications',
                            style: TextStyle(
                              fontSize: 18,
                              color: (lightTheme) ? const Color(0xff2c1d33) : const Color(0xffeeb462),
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

  Future getVariableValue() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    lightTheme = localStorage.getBool('theme');
    loggedIn = localStorage.getBool('loggedIn');
  }

}