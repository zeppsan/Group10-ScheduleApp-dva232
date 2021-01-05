import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:schedule_dva232/schedule/subfiles/CourseParser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedule_dva232/globalNotification.dart' as global;

import 'noteClass.dart';


  Map<DateTime, List<Lecture>> rawSchedule = Map<DateTime, List<Lecture>>();

  Future<void> parseSchedule() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    CourseParser parser = CourseParser(rawData: jsonDecode(localStorage.getString('rawSchedule')));
    parser.parseRawData();

    rawSchedule = parser.events;
    Future.delayed(Duration(milliseconds: 10), () async{
      findExam();
      removeExpiredItems();
    });

  }

  void findExam() {

    rawSchedule.forEach((key, value) {
      value.forEach((element) {

        if(element.moment.startsWith('TEN'))
          createNote(key, element);
      });
    });
  }

  void createNote(DateTime key, Lecture element){
    Note newNote;
    DateTime today = DateTime.now();
    int daysApart ;
    String title, content, courseCode, id, noteText = '';
    DateTime date;

    daysApart = DateTime(key.year, key.month, key.day).difference(DateTime(today.year, today.month, today.day)).inDays; //check how many days it is until exam

    courseCode = element.course_code.toUpperCase();
    title = 'Upcoming exam in $courseCode';
    date = key;
    content = '${element.moment}';

    if(daysApart == 21){ //21 days ahead
      noteText = '- is open for registration';
      id = 'open$courseCode${date.day.toString()}${date.month.toString()}'; //create an id with courseCode, moment and date

    }

    else if(daysApart == 10) { //10 days head
      noteText = '- last day for registration';
      id = 'lastday$courseCode${date.day.toString()}${date.month.toString()}'; //create an id with courseCode, moment and date

    }

    else if(daysApart <= 9){ // registration is closed
      noteText = '- is closed for registration';
      id = 'closed$courseCode${date.day.toString()}${date.month.toString()}'; //create an id with courseCode, moment and date
    }

    newNote = Note(
        title: title,
        content: content,
        courseCode: courseCode,
        date: date,
        id: id,
        noteText: noteText
    );

    var exists = global.notificationList.firstWhere((element) => element.id == newNote.id, orElse: () => null); //check if item already exists
    if(exists == null) {
      global.notificationList.add(newNote);
      global.numberOfItems++;
      global.newItem = true;

    }

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



