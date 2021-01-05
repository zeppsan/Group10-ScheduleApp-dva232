import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:schedule_dva232/schedule/subfiles/CourseParser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedule_dva232/globalNotification.dart' as global;

import 'noteClass.dart';


  Map<DateTime, List<Lecture>> rawSchedule = Map<DateTime, List<Lecture>>();

  Future<void> parseSchedule() async{
    print('in parseSchedule');
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    CourseParser parser = CourseParser(rawData: jsonDecode(localStorage.getString('rawSchedule')));
    parser.parseRawData();

    rawSchedule = parser.events;
    Future.delayed(Duration(milliseconds: 10), () async{
      findExam();
      removeExpiredItems();
    });
    print('done parseSchedule');
  }

  void findExam() {
    print('in findExam');
    rawSchedule.forEach((key, value) {
      value.forEach((element) {
        print(element);
        if(element.moment.startsWith('TEN'))
          createNote(key, element);
      });
    });
  }

  void createNote(DateTime key, Lecture element){
    Note newNote;
    DateTime today = DateTime.now();
    int daysApart ;
    String title, content, courseCode, id;
    DateTime date;

    daysApart = DateTime(key.year, key.month, key.day).difference(DateTime(today.year, today.month, today.day)).inDays; //check how many days it is until exam

    courseCode = element.course_code.toUpperCase();
    title = 'Upcoming exam in $courseCode';
    date = key;
    id = 'exam$courseCode${date.day.toString()}${date.month.toString()}'; //create an id with courseCode, moment and date

    if(daysApart == 21){ //21 days ahead
      content = '${element.moment} - is open for registration';
      newNote = Note(title: title, content: content, courseCode: courseCode, date: date, id: id);
    }

    else if(daysApart == 10) { //10 days head
      content = '${element.moment} - last day for registration';
      newNote = Note(title: title, content: content, courseCode: courseCode, date: date, id: id);
    }

    else if(daysApart <= 9){ // registration is closed
      content = '${element.moment} - is closed for registration';
      newNote = Note(title: title, content: content, courseCode: courseCode, date: date, id: id);
    }

    var exists = global.notificationList.firstWhere((element) => element.id == newNote.id, orElse: () => null); //check if item already exists
    if(exists == null) {
      global.notificationList.add(newNote);
      global.numberOfItems++;
      global.newItem = true;

    }
    print(global.numberOfItems);

  }

  void removeExpiredItems() {
    int expired;
    DateTime today = DateTime.now();

    global.notificationList.forEach((element) {
      expired =  DateTime(element.date.year, element.date.month, element.date.day).difference(DateTime(today.year, today.month, today.day)).inDays;

      if(expired < 0){
        element.expired = true;
      }
    });

    global.notificationList.removeWhere((element) => element.expired == true); //remove all expired notifications
  }



