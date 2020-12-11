
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

class CourseParser{

  Map<DateTime, List<Lecture>> events = Map<DateTime, List<Lecture>>();

  List<dynamic> rawData;

  CourseParser({this.rawData});

  /* This is the parent function of courseSorter, this one does the course looping
  * */
  void parseRawData(){
    rawData.forEach((element) async {
      await courseSorter(jsonDecode(element['schedule']));
    });
  }


  /* This function takes in the rawdata from the api-endpoint and loops trough the course in the json-string.
  *  It then adds each course occation into the events map, sorting them by datetime.
  * */
  void courseSorter(LinkedHashMap<String, dynamic> course) async {
    await course.forEach((lectureTime, lectureInformation) async {
      int year = await DateTime.fromMillisecondsSinceEpoch(int.parse(lectureTime)).year;
      int month = await DateTime.fromMillisecondsSinceEpoch(int.parse(lectureTime)).month;
      int day = await DateTime.fromMillisecondsSinceEpoch(int.parse(lectureTime)).day;
      DateTime target = DateTime(year, month, day);
      if(events[target] == null){
        events[target] = List<Lecture>();
        events[target].add(Lecture(lectureInformation['summary'], lectureInformation['dateStart'], lectureInformation['dateEnd'], lectureInformation['location'], lectureInformation['course_code']));
      } else {
        events[target].add(Lecture( lectureInformation['summary'], lectureInformation['dateStart'], lectureInformation['dateEnd'], lectureInformation['location'], lectureInformation['course_code']));
      }
      log("course code was : ${lectureInformation['course_code']}");
    });
  }

  static saveToLocalStorage(){

  }


}

/* This class is used to create a lecture. Each lecture has a summary, startTime, endTime, location.
* */
class Lecture{

  String summary;
  int startTime;
  int endTime;
  String location;
  String course_code;
  String moment;

  Lecture(summary, startTime, endTime, location, course_code){
    this.summary = summary;
    this.startTime = startTime;
    this.endTime = endTime;
    this.location = location;
    this.course_code = course_code;
    this.moment = getMoment(summary);
  }

  String getTime(int dateTime){
    if(startTime == 0)
      return "All day";
    String resultString = "";
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(dateTime * 1000);
    String minute = (date.minute.toString().length < 2)? "0${date.minute.toString()}": "${date.minute.toString()}";
    resultString = "${date.hour.toString()}:${minute}";
    return resultString;
  }

  String getMoment(String input){
    int momentIndex = input.indexOf("Moment");
    return input.substring(momentIndex + 8);
  }
}