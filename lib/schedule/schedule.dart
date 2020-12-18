import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'subfiles/CourseParser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:table_calendar/table_calendar.dart';
import 'subfiles/CourseParser.dart';
import 'package:http/http.dart' as http;
import 'subfiles/scheduleUpdater.dart';
import 'package:schedule_dva232/generalPages/settings.dart';

// Schedule Page
class Schedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("## in schedule ##");
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
        //Old view with add courses and notifications
        /*actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/scheduleSettings');
            },
            icon: Icon(
              Icons.add,
              color:  const Color(0xffdfb15b),
            ),

          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/scheduleSettings');
            },
            icon: Icon(
              Icons.notifications_none_rounded,
              color:  const Color(0xffdfb15b),
            ),
          ),
        ],*/
      ),
      endDrawer: Settings(),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: scheduleModule(),
      ),
      bottomNavigationBar: NavigationBarLoggedIn(),
    );
  }
}

class scheduleModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future calendarFuture = ScheduleUpdater.getEvents(context);
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
        });
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
  bool lightTheme;
  bool calendarRendered;
  _ScheduleCalendarState({this.courses, this.empty});

  final Color lectureTextColor = Colors.grey[800];


  @override
  void initState() {
    super.initState();
    calendarRendered = false;
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
              return Column(
                children: [
                  Container(
                    // Set the width of the container accordingly to the phones orientation
                    width: (MediaQuery.of(context).size.width > MediaQuery.of(context).size.height)? MediaQuery.of(context).size.height*0.6 : MediaQuery.of(context).size.width,
                    child: TableCalendar(
                      calendarStyle: CalendarStyle(
                        // Left color is light theme, right is darktheme
                          selectedColor: Color(0xffeeb462),
                          selectedStyle: TextStyle(
                              color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          todayColor: (lightTheme)? Colors.transparent : Colors.transparent,
                          todayStyle: TextStyle(
                              color: Color(0xffeeb462),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                          ),
                          markersColor: (lightTheme)? Colors.black : Colors.white,
                          markersMaxAmount: 1,
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonDecoration: BoxDecoration(
                          color: Color(0xffeeb462),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                        ),
                        formatButtonTextStyle: TextStyle(
                          color: Colors.black
                        ),
                      ),
                      initialCalendarFormat: CalendarFormat.twoWeeks,
                      availableCalendarFormats: { CalendarFormat.month:'Month',  CalendarFormat.week:'week', CalendarFormat.twoWeeks:'Two Weeks',},
                      calendarController: _calendarController,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      events: snapshot.data,
                      onCalendarCreated: (test1, test2, test3){
                          Future.delayed(Duration(milliseconds: 10), ()async{
                            _calendarController.setSelectedDay(DateTime.now(), animate: true, isProgrammatic: true, runCallback: true);
                          });
                      },
                      onDaySelected: (date, events, test) {
                        calendarRendered = true;
                        setState(() {
                          log(events.toString());
                          if(events.isNotEmpty){
                            _selectedEvents = events;
                            _selectedEvents.sort((a, b) => a.startTime.compareTo(b.startTime));
                          } else {
                            _selectedEvents = List<Lecture>();
                          }
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(8.0),
                      children: (_selectedEvents.length == 0 && calendarRendered == true)? [eventContainer("Morning", "Moment: Home Studies", "Night", "Anywhere", "YOU ARE FREE!!", Colors.lightBlueAccent)] : _selectedEvents.map((ev) {
                        return eventContainer(ev.getTime(ev.startTime), ev.moment,
                            ev.getTime(ev.endTime), ev.location, ev.course_code, ev.color);
                      }).toList(),
                    ),
                  ),
                ],
              );
              break;
            default:
              return Text("unexpected");
          }
        });
  }

  Future<Map<DateTime, List<Lecture>>> renderCalendar(List<dynamic> coursesToParse) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    lightTheme = await localStorage.getBool('theme');

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
              color: lightTheme? Colors.grey.withOpacity(0.5) : Colors.grey.withOpacity(0.1) ,
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
                      color: lectureTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Text(
                  '${startDate} - ${endDate}',
                  style: TextStyle(
                      color: lectureTextColor,
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
                    style: TextStyle(color: lectureTextColor),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      '${room}',
                      style: TextStyle(color: lectureTextColor, fontSize: 18, decoration: TextDecoration.underline),
                    ),
                    onPressed: (){
                      Navigator.pushNamed(context, '/searching', arguments: "${room}");
                    },
                  )
                ),
              ],
            )
          ],
        ));
  }
}
