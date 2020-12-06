
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

  Map<DateTime, List<dynamic>> events = Map<DateTime, List<dynamic>>();

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
        events[lectureDateTime] = await List<dynamic>();
        events[lectureDateTime].add(await Text(lectureInformation.toString()));
      } else {
        events[lectureDateTime].add( await Text(lectureInformation.toString()));
      }
    });
    print("DONE WITH THE PARSING");
    await events.keys.forEach((element) async {
      await print("Element was = ${events[element][0].toString()}");
    });
  }
}