import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;



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
      bottomNavigationBar: NavigationBarLoggedIn(),
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

  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState(){
    super.initState();
    List<Text> tempevents = List<Text>();
    tempevents.add(Text('test1'));
    tempevents.add(Text('test2'));
    _events = {
      DateTime(2020,12,06,10):tempevents,
    };
    _selectedEvents = [];
    _calendarController = CalendarController();

    //getEvents();
  }

  Widget build(BuildContext context) {

    return Column(
      children: [
        TableCalendar(
          calendarController: _calendarController,
          calendarStyle: CalendarStyle(
            todayColor: Colors.blue,
            selectedColor: Colors.orange,
          ),
          startingDayOfWeek: StartingDayOfWeek.monday,
          events: _events,
          onDaySelected: (date, events, test){
            setState(() {
              _selectedEvents = events;
            });
          },
        ),
       ... _selectedEvents.map((event) => event),
      ],
    );
  }

  Future<Map<DateTime, List<dynamic>>> getEvents() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    String url = "https://qvarnstrom.tech/api/schedule/update";
    var response = await http.get(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept' : 'application/json',
          'Authorization' : 'Bearer ' + token,
        },
    );
    print(response.body);
    return jsonDecode(response.body);
  }
}

