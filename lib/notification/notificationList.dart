
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_dva232/schedule/subfiles/CourseParser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Note{
  final String title;
  final String content;

  Note({this.title, this.content});
}

class NotificationList extends StatefulWidget {
  OverlayEntry overlayEntry;
  final double appBarSize;
  final bool hasData;
  List<dynamic> scheduleList;

  NotificationList({this.appBarSize, this.hasData, this.scheduleList});

  @override
  _NotificationList createState() => _NotificationList();
}

class _NotificationList extends State<NotificationList> with TickerProviderStateMixin{
  bool dropDownOpen = false;
  bool lightTheme;
  bool loggedIn;
  double containerHeight = 0.0;
  List<Lecture> notificationList;

  //var notifications = {'0': Note(title: 'MAA140', content:'Anmälan till tentan öppen'), '1' : Note(title: 'MAA140', content: 'Föreläsning 15 inställd')};

  @override
  void initState() {
    getScheduleUpdates();
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
        future: parseSchedule(context),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.done:
              if(notificationList != null)
                return Badge(
                  badgeContent: Text(notificationList.length.toString()),
                  toAnimate: true,
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
                if(notificationList != null)
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
                          itemCount: notificationList.length,
                          itemBuilder: (BuildContext context, int index){
                            return Card(
                              color: const Color(0xffeeb462),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(

                                    title: Text(notificationList[index].course_code),
                                    subtitle: Text(notificationList[index].moment),
                                    trailing: IconButton(
                                        icon: Icon(Icons.check)),
                                  )
                                ],
                              ),
                            );
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

  Future<Map<DateTime, List<Lecture>>> parseSchedule(context) async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    CourseParser parser = CourseParser(rawData: jsonDecode(localStorage.getString('rawSchedule')));
    await parser.parseRawData();
    return parser.events;
  }

  Future getScheduleUpdates() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    lightTheme = localStorage.getBool('theme');
    loggedIn = localStorage.getBool('loggedIn');
  }
}