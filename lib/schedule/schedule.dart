import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:table_calendar/table_calendar.dart';



class Schedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CheckLogin(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Schedule')),
      ),
      body: Column(
        children: [
          ScheduleWidget(),
        ],
      ),
      bottomNavigationBar: NaviagtionBarLoggedIn(),
    );
  }
  void CheckLogin(context) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    print(localStorage.getString('token'));
    if(localStorage.getString('token') == null){
      Navigator.pushReplacementNamed(context, '/');
    }
  }
}

class ScheduleWidget extends StatefulWidget {
  @override
  _ScheduleWidgetState createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  @override

  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState(){
    super.initState();

    _calendarController = CalendarController();
  }

  Widget build(BuildContext context) {
    return Container(
      child: TableCalendar(
        calendarController: _calendarController,
        calendarStyle: CalendarStyle(
          todayColor: Colors.blue,
          selectedColor: Colors.orange,
        ),
        startingDayOfWeek: StartingDayOfWeek.monday,
        events: {
          DateTime(2020, 12, 12, 0, 0, ):List(),
        },
      ),
    );
  }
}

