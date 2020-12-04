import 'package:flutter/material.dart';
import 'package:schedule_dva232/login/login.dart';
import 'package:schedule_dva232/login/register.dart';
import 'package:schedule_dva232/map/map.dart';
import 'package:schedule_dva232/schedule/addCourse.dart';
import 'package:schedule_dva232/schedule/schedule.dart';
import 'package:schedule_dva232/schedule/scheduleSettings.dart';
import 'package:schedule_dva232/schedule/thisweek.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Login(),
      '/register': (context) => Register(),
      '/schedule': (context) => Schedule(),
      '/scheduleSettings': (context) => ScheduleSettings(),
      '/addCourse': (context) => AddCourse(),
      '/thisweek': (context) => Thisweek(),
      '/map': (context) => Map(),
    },
  ));
}