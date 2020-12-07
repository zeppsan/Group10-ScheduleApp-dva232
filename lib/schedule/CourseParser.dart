
/*
*
* Class will be used to parse the course json that is returned from the localstorage or the database/api.
* For each course there will be a instance created where the developer then can harvest various information.
*
* */

import 'dart:collection';
import 'package:flutter/material.dart';
import 'dart:convert';

class CourseParser{

  Map<DateTime, List<Lecture>> events = Map<DateTime, List<Lecture>>();

  List<dynamic> rawData;

  CourseParser({this.rawData});

  void parseRawData(){
    rawData.forEach((element) async {
      await courseSorter(jsonDecode(element['schedule']));
    });
  }

  // BUGG! ONLY SHOWS 1 COURSE PER DAY. THIS IS CAUSED BY THE TIME OVERLAPPING OF COURSE
  void courseSorter(LinkedHashMap<String, dynamic> course) async {
    await course.forEach((lectureTime, lectureInformation) async {
      await print(lectureTime);
      DateTime lectureDateTime = await DateTime.fromMillisecondsSinceEpoch(int.parse(lectureTime));
      if(events[lectureDateTime] == null){
        events[lectureDateTime] = await List<Lecture>();
        events[lectureDateTime].add(await Lecture(lectureInformation['summary'], lectureInformation['dateStart'], lectureInformation['dateEnd']));
      } else {
        events[lectureDateTime].add(await Lecture( lectureInformation['summary'], lectureInformation['dateStart'], lectureInformation['dateEnd']));
      }
    });
  }
}

class Lecture{

  String summary;
  int startTime;
  int endTime;

  Lecture(summary, startTime, endTime){
    this.summary = summary;
    this.startTime = startTime;
    this.endTime = endTime;
  }

  String getTime(int dateTime){
    String resultString = "";
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(dateTime * 1000);
    String minute = (date.minute.toString().length < 2)? "0${date.minute.toString()}": "${date.minute.toString()}";
    resultString = "${date.hour.toString()}:${minute}";
    return resultString;
  }


}