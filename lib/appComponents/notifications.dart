
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:schedule_dva232/notice_page.dart';
import 'package:schedule_dva232/schedule/subfiles/CourseParser.dart';
import 'package:schedule_dva232/schedule/thisweek.dart';

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
  AnimationController controller;
  double containerHeight = 0.0;

  var notifications = {'0': Note(title: 'MAA140', content:'Anmälan till tentan öppen'), '1' : Note(title: 'MAA140', content: 'Föreläsning 15 inställd')};

  @override
  void initState() {
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
    return Badge(
      badgeContent: Text(notifications.length.toString()),
      toAnimate: true,
      animationType: BadgeAnimationType.scale,
      position: BadgePosition.topEnd(end: 5, top: 5),
      child: IconButton(
        icon: Icon(Icons.notifications_rounded),
        onPressed: () {
          if(menuOpen){
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
                        color: const Color(0xff2c1d33),
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
            ],

              //child: Material (
                //color: Colors.transparent,

              //),
            ),

        );
      }
    );
  }
}