import 'package:flutter/material.dart';
import 'package:schedule_dva232/login/login.dart';
import 'package:schedule_dva232/login/register.dart';
import 'package:schedule_dva232/map/map.dart';
import 'package:schedule_dva232/schedule/addCourse.dart';
import 'package:schedule_dva232/schedule/schedule.dart';
import 'package:schedule_dva232/schedule/scheduleSettings.dart';
import 'package:schedule_dva232/schedule/thisweek.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:schedule_dva232/theme/themes.dart';
import 'package:schedule_dva232/generalPages/settings.dart';

Future main() async {
  await ThemeManager.initialise();
  runApp(App());
}

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  ThemeBuilder(
      defaultThemeMode: ThemeMode.light,
      darkTheme: AppTheme.darkTheme,
      lightTheme: AppTheme.lightTheme,
      builder: (context, regularTheme, darkTheme, themeMode) => MaterialApp(
      theme: regularTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        initialRoute: '/',
        routes: {
          '/': (context) => Login(),
          '/register': (context) => Register(),
          '/schedule': (context) => Schedule(),
          '/scheduleSettings': (context) => ScheduleSettings(),
          '/addCourse': (context) => AddCourse(),
          '/thisweek': (context) => Thisweek(),
          '/map': (context) => Map(),
          '/settings': (context) => Settings(),
        },
      ),
    );
  }
}