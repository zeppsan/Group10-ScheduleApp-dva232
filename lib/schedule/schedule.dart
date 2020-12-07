import 'dart:collection';
import 'dart:convert';
import 'dart:ui';
import 'dart:io';
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
        title: Text('Schedule'),
        actions: [
          FlatButton.icon(
              onPressed: (){
                Navigator.pushNamed(context, '/scheduleSettings');
              },
              icon: Icon(
                  Icons.settings,
                color: Colors.white,
              ),
              label: Text(""),
          ),
        ],
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
  String noScheduleError = "Sorry, we could not find your schedule...";

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
                  {
                    // Data is retrieved. Check if the data is null, if so, return Text that displays that there is no schedule to show.
                    if (snapshot.data == null) {
                      // Data = null;
                      return Text(
                        noScheduleError,
                        style: TextStyle(color: Colors.blue, fontSize: 24),
                      );
                    } else {
                      // Data is not null
                      return ScheduleCalendar(snapshot.data);
                    }
                  }
                  break;
                default:
                  return ScheduleCalendar(snapshot.data);
              }
            }),
      ],
    );
  }

  /*
  * Functions gets schedule raw-data from the locatstorage if possible, else, it fetches fresh information from the database.
  * If there however is no internet at that time, return an empty list of events and display an "empty schedule" for the user.
  * */
  Future<List<dynamic>> getEvents() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    List<dynamic> result = List<dynamic>();
    // Check if there is an schedule saved already. If so, do not update unless it's out of date.
    if (localStorage.containsKey('rawSchedule')) {
      result = jsonDecode(localStorage.getString('rawSchedule'));
    } else {
      // If there is no schedule saved in the localStorage

      // The following try-catch is taken from stackOVerflow. Link below:
      // https://stackoverflow.com/questions/49648022/check-whether-there-is-an-internet-connection-available-on-flutter-app
      try {
        final internetCheck = await InternetAddress.lookup('google.com');
        if (internetCheck.isNotEmpty &&
            internetCheck[0].rawAddress.isNotEmpty) {
          // Phone has internet access
          String token = await localStorage.getString('token');
          String url = "https://qvarnstrom.tech/api/schedule/update";

          // Generate the http request for fetching the schedule
          var response = await http.get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ' + token,
            },
          );
          if (response.statusCode == 401) {
            // user is holding an invalid authentication token. Sen user to login screen.
            Navigator.pushReplacementNamed(context, '/');
          }
          // Save the new schedule to the local storage
          await localStorage.setString('rawSchedule', response.body);
          result = jsonDecode(response.body);
        }
      } on SocketException catch (_) {
        // Phone does not have internet access
        result = null;
      }
    }

    // Return result to the Future
    return result;
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
  Map<DateTime, List<Lecture>> _events;
  List<Lecture> _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  List<CourseParser> courseObjects;
  Future calendarFuture;
  Future listViewFuture;
  List<dynamic> listEvents;

  _ScheduleCalendarState(List<dynamic> httpResult) {
    this.courses = httpResult;
  }

  @override
  void initState() {
    super.initState();
    listEvents = List<Lecture>();
    _selectedEvents = [];
    _calendarController = CalendarController();
    courseObjects = List<CourseParser>();
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
              return Container(
                child: Column(
                  children: [
                    Container(
                      child: TableCalendar(
                        calendarStyle: CalendarStyle(
                          selectedColor: Colors.blue,
                          todayColor: Colors.blue[400]
                        ),
                        initialSelectedDay: DateTime.now(),
                        calendarController: _calendarController,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        events: snapshot.data,
                        onDaySelected: (date, events, test) {
                          setState(() {
                            _selectedEvents = events;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 150,
                      width: 400,
                      child: ListView(
                        padding: EdgeInsets.all(8.0),
                        children: _selectedEvents.map((ev){
                          return eventContainer(ev.getTime(ev.startTime), ev.summary, ev.getTime(ev.endTime), "zoom");
                        }).toList(),
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

  Future<Map<DateTime, List<Lecture>>> renderCalendar(List<dynamic> coursesToParse) async {
    Map<DateTime, List<dynamic>> test = Map<DateTime, List<dynamic>>();

    var parser = CourseParser(rawData: coursesToParse);

    parser.parseRawData();

    return parser.events;
  }

  Widget eventContainer(startDate, summary, endDate, room){
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blue[300], Colors.blue[500]],
          ),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
              '${startDate} -> ${endDate}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
          ),
          Text(
              '${summary}',
            style: TextStyle(
                color: Colors.white
            ),
          ),
          Text(
              'Location: ${room}',
            style: TextStyle(
                color: Colors.white,
              fontSize: 18
            ),
          ),
        ],
      )
    );
  }


}