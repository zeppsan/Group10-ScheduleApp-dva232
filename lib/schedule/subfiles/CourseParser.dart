/*
*
* Class will be used to parse the course json that is returned from the localstorage or the database/api.
* For each course there will be a instance created where the developer then can harvest various information.
*
* */

import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/*
*
* Eric Qvarnström
*
* */

class CourseParser {
  Map<DateTime, List<Lecture>> events = Map<DateTime, List<Lecture>>();

  List<dynamic> rawData;

  CourseParser({this.rawData});

  /* This is the parent function of courseSorter, this one does the course looping
  * */
  void parseRawData() {
    rawData.forEach((element) async {
      courseSorter(jsonDecode(element['schedule']));
    });
  }

  /* This function takes in the rawdata from the api-endpoint and loops trough the course in the json-string.
  *  It then adds each course occation into the events map, sorting them by datetime.
  * */
  void courseSorter(LinkedHashMap<String, dynamic> course) async {
    course.forEach((lectureTime, lectureInformation) async {
      int year = DateTime.fromMillisecondsSinceEpoch(int.parse(lectureTime)).year;
      int month =  DateTime.fromMillisecondsSinceEpoch(int.parse(lectureTime)).month;
      int day = DateTime.fromMillisecondsSinceEpoch(int.parse(lectureTime)).day;
      DateTime target = DateTime(year, month, day);
      if (events[target] == null) {
        events[target] = List<Lecture>();
        events[target].add(Lecture(
            lectureInformation['summary'],
            lectureInformation['dateStart'],
            lectureInformation['dateEnd'],
            lectureInformation['location'],
            lectureInformation['course_code']));
      } else {
        events[target].add(Lecture(
            lectureInformation['summary'],
            lectureInformation['dateStart'],
            lectureInformation['dateEnd'],
            lectureInformation['location'],
            lectureInformation['course_code']));
      }
    });
  }

  static void searchForChanges() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (localStorage.containsKey('rawSchedule')) {
      if (localStorage.containsKey('token')) {
        String token = localStorage.getString('token');
        log("testte");
        CourseParser parser1 = CourseParser(
            rawData: jsonDecode(localStorage.getString('rawSchedule')));
        parser1.parseRawData();

        List<String> changes = List<String>();
        Map<DateTime, List<Lecture>> old_sched = parser1.events;
        Map<DateTime, List<Lecture>> new_sched = Map<DateTime, List<Lecture>>();

        String url = "https://qvarnstrom.tech/api/schedule/update";
        var response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + token,
          },
        );

        Future.delayed(Duration(seconds: 1), () {
          CourseParser parser2 =
              CourseParser(rawData: jsonDecode(response.body));
          parser2.parseRawData();
          new_sched = parser2.events;

          Future.delayed(Duration(seconds: 1), () {
            // Check for differences in the schedule
            old_sched.forEach((key, value) {
              for (var i = 0; i < value.length; i++) {
                try {
                  if (old_sched[key][i].startTime != new_sched[key][i].startTime) {
                    changes.add("${old_sched[key][i].course_code}:${old_sched[key][i].startTime}:${old_sched[key][i].moment}:- time has been changed");
                  }

                  if (old_sched[key][i].location != new_sched[key][i].location ) {
                    changes.add("${old_sched[key][i].course_code}:${old_sched[key][i].startTime}:${old_sched[key][i].moment}:- location has been changed");
                  }

                } catch (Exception) {
                  // The index does not exist... Lecture moved
                  changes.add("${old_sched[key][i].course_code}:${old_sched[key][i].startTime}:${old_sched[key][i].moment}:- is removed from schedule");
                }
              }
            });

            Future.delayed(Duration(seconds: 2), () {
              if (changes.length > 0) {
                localStorage.setString('scheduleUpdates', jsonEncode(changes));
                Future.delayed(Duration(seconds: 1), (){
                  log(localStorage.getString('scheduleUpdates'));
                });
              }
            });
          });
        });
      }
    }
  }
}

/* This class is used to create a lecture. Each lecture has a summary, startTime, endTime, location.
* */
class Lecture {
  String summary;
  int startTime;
  int endTime;
  String location;
  String course_code;
  String moment;
  Color color;

  Lecture(summary, startTime, endTime, location, course_code) {
    this.summary = summary;
    this.startTime = startTime;
    this.endTime = endTime;
    this.location = location;
    this.course_code = course_code;
    this.moment = getMoment(summary);

    setColor();
  }

  String getTime(int dateTime) {
    if (startTime == 0) return "All day";
    String resultString = "";
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(dateTime * 1000);
    String hour = (date.hour.toString().length < 2)
        ? "0" + date.hour.toString()
        : date.hour.toString();
    String minute = (date.minute.toString().length < 2)
        ? "0${date.minute.toString()}"
        : "${date.minute.toString()}";
    resultString = "${hour}:${minute}";
    return resultString;
  }

  String getMoment(String input) {
    int momentIndex = input.indexOf("Moment");
    return input.substring(momentIndex + 8);
  }

  void setColor() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (!localStorage.containsKey('course_color')) {
      color = Colors.lightBlueAccent;
      return;
    }

    LinkedHashMap colors = jsonDecode(localStorage.getString('course_color'));
    if (colors[course_code] != null) {
      color = Color(int.parse(colors[course_code]));
    } else {
      color = Colors.lightBlueAccent;
    }
  }
}
