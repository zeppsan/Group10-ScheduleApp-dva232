
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:schedule_dva232/notice_page.dart';
import 'package:schedule_dva232/schedule/subfiles/CourseParser.dart';
import 'package:schedule_dva232/schedule/thisweek.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Note{
  final String title;
  final String content;

  Note({this.title, this.content});
}

class NotificationPage extends StatefulWidget {
  OverlayEntry overlayEntry;
  final double appBarSize;

  NotificationPage({this.appBarSize});

  @override
  _NotificationPage createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationPage> with TickerProviderStateMixin{
  bool menuOpen = false;
  bool lightTheme;
  bool loggedIn;
  AnimationController controller;
  double containerHeight = 0.0;
  List<String> scheduleUpdate;

  var notifications = {'0': Note(title: 'MAA140', content:'Anmälan till tentan öppen'), '1' : Note(title: 'MAA140', content: 'Föreläsning 15 inställd')};

  @override
  void initState() {
    getScheduleUpdates();
    print('getScheduleUpdate done');
    print(scheduleUpdate);
    controller = AnimationController(vsync: this, duration: Duration(seconds: 5),);
    super.initState();
  }

  void openMenu(){

    widget.overlayEntry = overlayEntryBuilder();
    Overlay.of(context).insert(widget.overlayEntry);
    setState(() {
      menuOpen = true;
    });
  }

  void closeMenu(){

    setState(() {
      menuOpen = false;
    });
    widget.overlayEntry.remove();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getScheduleUpdates(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.done:
              if(scheduleUpdate != null)
                return Badge(
                  badgeContent: Text(notifications.length.toString()),
                  toAnimate: true,
                  animationType: BadgeAnimationType.scale,
                  position: BadgePosition.topEnd(end: 5, top: 5),
                  child: IconButton(
                    icon: Icon(Icons.notifications_rounded),
                    onPressed: () {
                      if (menuOpen) {
                        print('closing menu');
                        closeMenu();
                        menuOpen = false;
                      }
                      else {
                        print('openMenu');
                        openMenu();
                        menuOpen = true;
                      }
                    },
                  ),
                );

            /* else if(!loggedIn) {
                print('bygger');
                return Badge(
                  badgeContent: Text('0'),
                  toAnimate: true,
                  animationType: BadgeAnimationType.scale,
                  badgeColor: Colors.grey[600],
                  position: BadgePosition.topEnd(end: 5, top: 5),
                  child: IconButton(
                    icon: Icon(Icons.notifications_rounded),
                  ),
                );
              }*/
              else
                return IconButton(
                  icon: Icon(Icons.notifications_rounded),
                  onPressed: () {
                    if (menuOpen) {
                      print('closing menu');
                      closeMenu();
                      menuOpen = false;
                    }

                    else {
                      print('openMenu');
                      openMenu();
                      menuOpen = true;
                    }
                    },
                );
              break;

              default:
                return Text('error');
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
                  closeMenu();
                },
                child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                ),
              ),
              if(scheduleUpdate != null)
              AnimatedContainer(
                height: menuOpen ? MediaQuery.of(context).size.height * 0.6 : 0.0,
                duration: Duration(seconds: 5),
                curve: Curves.fastOutSlowIn,
                child: Padding(
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
                        itemCount: notifications.length,
                        itemBuilder: (BuildContext context, int index){
                          return Card(
                            color: const Color(0xffeeb462),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(

                                  title: Text(notifications[index.toString()].title),
                                  subtitle: Text(notifications[index.toString()].content),
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

  Future getScheduleUpdates() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    scheduleUpdate = localStorage.getStringList('scheduleUpdate');
    lightTheme = localStorage.getBool('theme');
    loggedIn = localStorage.getBool('loggedIn');
    print('lightTheme: ');
    print(lightTheme);
    print('loggedIn: ');
    print(loggedIn);
    print('end');
  }
}