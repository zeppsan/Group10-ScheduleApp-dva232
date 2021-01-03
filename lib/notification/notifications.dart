
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_dva232/notification/notificationList.dart';
import 'package:schedule_dva232/schedule/subfiles/scheduleUpdater.dart';



class NotificationPage extends StatefulWidget {
  final double appBarSize;

  NotificationPage({this.appBarSize});

  @override
  _NotificationPage createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationPage> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Future scheduleFuture = ScheduleUpdater.getEvents(context);
    return FutureBuilder(
      future: scheduleFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if(snapshot.hasData){
              print('has data');
            return NotificationList(appBarSize: widget.appBarSize, hasData: true);
            }
            else {
              print('no data');
              return NotificationList(appBarSize: widget.appBarSize, hasData: false);
            }
            break;

            default:
              return NotificationList(appBarSize: widget.appBarSize, hasData: false);
        }
      }
    );
  }
}