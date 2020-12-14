import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
        actions: [
          FlatButton.icon(
            onPressed: () {
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ScheduleWidget(),
      ),
      bottomNavigationBar: NavigationBarLoggedIn(),
    );
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
    return Container(
      child: FutureBuilder(
          future: calendarFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('Something went wrong');
                break;
              case ConnectionState.waiting:
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: CircularProgressIndicator()
                    )
                );
                break;
              case ConnectionState.done:
                {
                  List<dynamic> data = snapshot.data;
                  // Data is retrieved. Check if the data is null, if so, return Text that displays that there is no schedule to show.
                  if (data == null || data.length == 0) {
                    // Data = null;
                    return ScheduleCalendar(
                        courses: snapshot.data, empty: true);
                  } else {
                    // Data is not null
                    return ScheduleCalendar(
                        courses: snapshot.data, empty: false);
                  }
                }
                break;
              default:
                return ScheduleCalendar(courses: snapshot.data);
            }
          }),
    );
  }

  /*
  * Functions gets schedule raw-data from the locatstorage if possible, else, it fetches fresh information from the database.
  * If there however is no internet at that time, return an empty list of events and display an "empty schedule" for the user.
  * */

  Future<List<dynamic>> getEvents() async {

    /*await Future.delayed(Duration(seconds: 1), ()async{

    });*/
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool hasInternetAccess = true;

    // Checks if the user has internet or not
    try {
      final internetCheck = await InternetAddress.lookup('google.com');
      if (!internetCheck.isNotEmpty &&
          !internetCheck[0].rawAddress.isNotEmpty) {
        // Phone does not have internet access
        hasInternetAccess = false;
      }
    } on SocketException catch (_) {
      // Phone does not have internet access
      hasInternetAccess = false;
    }

    // Check if the user is logged in to an account that has online-sync
    if(hasInternetAccess){
      if (localStorage.containsKey('token')) {
        String token = await localStorage.getString('token');
        String url = "https://qvarnstrom.tech/api/schedule/update-check";
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
          localStorage.remove('token');
          Navigator.pushReplacementNamed(context, '/');
        }
        // NO UPDATE AVALIBLE
        if(response.statusCode == 204){
          // CHECK SO THAT THE DATA IS DOWNLOADED
          if(!localStorage.containsKey('rawSchedule')){
            String token = await localStorage.getString('token');
            String url = "https://qvarnstrom.tech/api/schedule/update";
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
              localStorage.remove('token');
              Navigator.pushReplacementNamed(context, '/');
            }
            // Save the new schedule to the local storage
            if (response.body != null)
              await localStorage.setString('rawSchedule', response.body);
            return jsonDecode(response.body);
          } else {
            return jsonDecode(localStorage.getString('rawSchedule'));
          }
        } else {
          // UPDATE IS AVALIBLE, DOWNLOAD IT AND APPLY!
          String token = await localStorage.getString('token');
          String url = "https://qvarnstrom.tech/api/schedule/update";
          var response = await http.get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ' + token,
            },
          );
          await localStorage.setString('rawSchedule', response.body);
          return jsonDecode(response.body);
        }
      }

      // IF THE USER IS NOT LOGGED IN, FETCH DATA FROM DATABASE
      if (localStorage.containsKey('course_list')) {

        String courses = localStorage.getString('course_list');
        var url = 'https://qvarnstrom.tech/api/schedule/updateNonUser';

        Map data = {'course_list': localStorage.getString('course_list')};

        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(url,
            headers: {"Content-Type": "application/json"}, body: body);
        if (response.statusCode == 200) {
          await localStorage.setString('rawSchedule', response.body);
          return jsonDecode(response.body);
        } else {
          print("Database error, could not fetch");
        }
      }
    } else {
      print("here we are ");
      // IF THE USER HAS NO INTERNET ACCESS
      // THE ONLY THING WE CAN DO IS TO RETURN THE ALREADY EXISTING SCHEDULE
      if(localStorage.containsKey('rawSchedule')){
        return jsonDecode(localStorage.getString('rawSchedule'));
      } else {
        return null;
      }
    }

    // if there is no course_subscription either, return null;
    return null;
  }
}

class ScheduleCalendar extends StatefulWidget {
  @override
  List<dynamic> courses;
  bool empty;

  ScheduleCalendar({this.courses, this.empty});

  _ScheduleCalendarState createState() =>
      _ScheduleCalendarState(courses: courses, empty: empty);
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
  CourseParser parser;
  bool empty;
  String noScheduleError =
      "Seems like you don't subscribe on any schedules, add some!";

  _ScheduleCalendarState({this.courses, this.empty});

  @override
  void initState() {
    super.initState();
    listEvents = List<Lecture>();
    _selectedEvents = List<Lecture>();
    _calendarController = CalendarController();
    courseObjects = List<CourseParser>();
    calendarFuture = renderCalendar(courses);

    if (empty == null){
      empty = false;
    }
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
              return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: CircularProgressIndicator()
                  )
              );
              break;
            case ConnectionState.done:
              return ListView(children: [
                Container(
                  child: TableCalendar(
                    calendarStyle: CalendarStyle(
                        selectedColor: Colors.blue,
                        todayColor: Colors.blue[200]),
                    initialSelectedDay: DateTime.now(),
                    calendarController: _calendarController,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    events: snapshot.data,
                    onDaySelected: (date, events, test) {
                      setState(() {
                        if(events.isNotEmpty){
                          _selectedEvents.sort((a, b) => a.startTime.compareTo(b.startTime));
                          _selectedEvents = events;
                          log(events.toString());
                          log(_selectedEvents.toString());
                          log(snapshot.data.toString());
                        } else {
                          _selectedEvents.clear();
                          _selectedEvents.add(Lecture("Moment: Home Studies", 0, 0, "Anywhere", "YOU ARE FREE!!"));
                        }
                      });
                    },
                  ),
                ),
                Container(
                  child: Text(
                      (empty)? 'No courses in your schedule': "",
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 1000,
                  width: 400,
                  child: ListView(
                    padding: EdgeInsets.all(8.0),
                    children: _selectedEvents.map((ev) {
                      return eventContainer(ev.getTime(ev.startTime), ev.moment,
                          ev.getTime(ev.endTime), ev.location, ev.course_code, ev.color);
                    }).toList(),
                  ),
                ),
                Text(
                    "test"
                ),
              ]);
              break;
            default:
              return Text("unexpected");
          }
        });
  }

  Future<Map<DateTime, List<Lecture>>> renderCalendar(List<dynamic> coursesToParse) async {

    parser = CourseParser(rawData: coursesToParse);

    await parser.parseRawData();


    return parser.events;
  }

  Widget eventContainer(startDate, moment, endDate, room, course_code, color) {
    return Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        decoration: BoxDecoration(
         color: color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${course_code}',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Text(
                  '${startDate} -> ${endDate}',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    '${moment}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Text(
                    'Location: ${room}',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
