import 'dart:collection';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_dva232/schedule/subfiles/CourseParser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedule_dva232/globalNotification.dart' as global;

import 'noteClass.dart';


  Map<DateTime, List<Lecture>> rawSchedule = Map<DateTime, List<Lecture>>();
  List<dynamic> updateCourseList;


  Future<void> parseSchedule() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    //check for changes in schedule
    CourseParser.searchForChanges();
    Future.delayed(Duration(seconds: 2), () {
      updateCourseList = jsonDecode(localStorage.getString('scheduleUpdates'));
      print('inside checkforupdates');
      if(updateCourseList != null) {
      // remove scheduleUpdates from localStorage to avoid duplicated data
        localStorage.remove('scheduleUpdates');
        print('list not null');
        if (updateCourseList.isNotEmpty) {
          print('list not empty');

          parseChanges();
        }
      }
    });



    //check for upcoming exams
    CourseParser parser = CourseParser(rawData: jsonDecode(localStorage.getString('rawSchedule')));
    parser.parseRawData();

    rawSchedule = parser.events;
    Future.delayed(Duration(milliseconds: 10), () async{
      findExam();
      removeExpiredItems();
    });

  }

  Future<void> getColor() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    LinkedHashMap colors = jsonDecode(localStorage.getString('course_color'));

  }

  void findExam() {

    rawSchedule.forEach((key, value) {
      value.forEach((element) {

        if(element.moment.startsWith('TEN'))
          createExamNote(key, element);
      });
    });
  }

  void createExamNote(DateTime key, Lecture element){
    Note newNote;
    DateTime today = DateTime.now();
    int daysApart ;
    String title, content, courseCode, id, noteText = '';
    DateTime date;
    Color color;

    daysApart = DateTime(key.year, key.month, key.day).difference(DateTime(today.year, today.month, today.day)).inDays; //check how many days it is until exam

    courseCode = element.course_code.toUpperCase();
    title = 'Upcoming exam in $courseCode';
    date = key;
    content = '${element.moment}';
    color = element.color;

    if(daysApart == 21){ //21 days ahead
      noteText = '- is open for registration';
      id = 'open$courseCode${date.day.toString()}${date.month.toString()}'; //create an id with courseCode, moment and date

    }

    else if(daysApart == 10) { //10 days head
      noteText = '- last day for registration';
      id = 'lastday$courseCode${date.day.toString()}${date.month.toString()}'; //create an id with courseCode, moment and date

    }

    else if(daysApart == 9){ // registration is closed
      noteText = '- is closed for registration';
      id = 'closed$courseCode${date.day.toString()}${date.month.toString()}'; //create an id with courseCode, moment and date
    }

    if(noteText != ''){
      newNote = Note(
        title: title,
        content: content,
        courseCode: courseCode,
        date: date,
        id: id,
        noteText: noteText,
        color: color,
      );

      addNote(newNote);
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

    //remove all expired notifications
    global.notificationList.removeWhere((element) => element.expired == true);

  }

  void parseChanges() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    LinkedHashMap colors = jsonDecode(localStorage.getString('course_color'));
    Note newNote;

    String courseCode;
    DateTime date;
    DateTime today = DateTime.now();
    Color color;


    //loop through all element i list do get values
    List<String> splitString = List<String>();
    updateCourseList.forEach((element) {

      splitString = element.split(':');
      //String dateWithT = splitString[1].substring(0,8) + 'T' + splitString[1].substring(8); //change string to be able to pare to DateTime
      int year = DateTime.fromMillisecondsSinceEpoch(int.parse(splitString[1])).year;
      int month = DateTime.fromMillisecondsSinceEpoch(int.parse(splitString[1])).month;
      int day = DateTime.fromMillisecondsSinceEpoch(int.parse(splitString[1])).day;

      date = DateTime(year, month, day);

      int daysPast = DateTime(date.year, date.month, date.day).difference(DateTime(today.year, today.month, today.day)).inDays;
      if(daysPast >= 0) { // if date hasn't already past
        courseCode = splitString[0];

        if (colors[courseCode] != null) {
          color = Color(int.parse(colors[courseCode]));
        } else {
          color = Colors.lightBlueAccent;
        }
        newNote = Note(
          title: 'Schedule change in $courseCode',
          content: splitString[2],
          courseCode: courseCode,
          date: date,
          id: element,
          noteText: splitString[3],
          color: color,
        );

        print('add schedule change');
        addNote(newNote);
      }
    });


  }

  void addNote(Note note){
    print(global.notificationList.length);
    var exists = global.notificationList.firstWhere((element) => element.id == note.id, orElse: () => null); //check if item already exists
    print('before exists');
    print(exists);
    if(exists == null) {
      global.notificationList.add(note);
      global.newItem = true;
    }
    //print(global.notificationList.length);
  }



