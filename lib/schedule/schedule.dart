import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_dva232/schedule/CourseParser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:table_calendar/table_calendar.dart';
import 'CourseParser.dart';
import 'package:http/http.dart' as http;

// Schedule Page
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
    if (localStorage.getString('token') == null) {
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
  Future calendarFuture;

  @override
  void initState() {
    super.initState();

    calendarFuture = getEvents();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
            future: calendarFuture,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Something went wrong');
                  break;
                case ConnectionState.waiting:
                  return Text('waiting');
                  break;
                case ConnectionState.done:
                  print("data from http.get is : ${snapshot.data}");
                  return ScheduleCalendar(snapshot.data);
                  break;
                default:
                  return ScheduleCalendar(snapshot.data);
              }
            }),
      ],
    );
  }

  Future<List<dynamic>> getEvents() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    String url = "https://qvarnstrom.tech/api/schedule/update";
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token,
      },
    );

    return jsonDecode(response.body);
  }
}

class ScheduleCalendar extends StatefulWidget {
  @override
  List<dynamic> courses;

  ScheduleCalendar(List<dynamic> httpResult) {
    this.courses = httpResult;
  }

  _ScheduleCalendarState createState() => _ScheduleCalendarState(courses);
}

class _ScheduleCalendarState extends State<ScheduleCalendar> {
  List<dynamic> courses;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  List<CourseParser> courseObjects;
  Future calendarFuture;
  Future listViewFuture;

  _ScheduleCalendarState(List<dynamic> httpResult) {
    this.courses = httpResult;
  }

  @override
  void initState() {
    super.initState();
    _selectedEvents = [];
    _calendarController = CalendarController();
    courseObjects = List<CourseParser>();
    print("There are ${courses.length} courses to be parsed");
    calendarFuture = renderCalendar(courses);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: calendarFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Something went wrong');
              break;
            case ConnectionState.waiting:
              return Text('waiting');
              break;
            case ConnectionState.done:
              print("data is : ${snapshot.data}");
              return Container(
                child: Column(
                  children: [
                    Container(
                      child: TableCalendar(
                        calendarController: _calendarController,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        events: snapshot.data,
                        onDaySelected: (date, events, test) {
                          print(events);
                        },
                      ),
                    ),
                  ],
                ),
              );
              break;
            default:
              return ScheduleCalendar(courses);
          }
        });
  }

  Future<Map<DateTime, List<dynamic>>> renderCalendar(
      List<dynamic> coursesToParse) async {
    Map<DateTime, List<dynamic>> test = Map<DateTime, List<dynamic>>();

    var parser = CourseParser(rawData: coursesToParse);

    parser.parseRawData();

    return parser.events;
  }
}
