import 'package:flutter/material.dart';
import 'package:schedule_dva232/map/map.dart';
import 'package:schedule_dva232/schedule/addCourse.dart';
import 'package:schedule_dva232/schedule/schedule.dart';
import 'package:schedule_dva232/schedule/scheduleSettings.dart';
import 'package:schedule_dva232/schedule/thisweek.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:schedule_dva232/theme/themes.dart';
import 'package:schedule_dva232/generalPages/settings.dart';
import 'package:schedule_dva232/login/loginMain.dart';
import 'package:shared_preferences/shared_preferences.dart';

var theme;

Future main() async {
  await ThemeManager.initialise();
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  if(!localStorage.containsKey('theme')) //if first time open app set to true - default lightmode
    localStorage.setBool('theme', true);

  if(localStorage.getBool('theme')) //if true get lightmode
    theme = ThemeMode.light;
  else
    theme = ThemeMode.dark; //if false get darkmode
  runApp(App());
}

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  ThemeBuilder(
      defaultThemeMode: theme,
      darkTheme: AppTheme.darkTheme,
      lightTheme: AppTheme.lightTheme,
      builder: (context, regularTheme, darkTheme, themeMode) => MaterialApp(
        theme: regularTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        initialRoute: '/',
        routes: {
            '/': (context) => LoginMain(),
            '/schedule': (context) => Schedule(),
            '/scheduleSettings': (context) => ScheduleSettings(),
            '/addCourse': (context) => AddCourse(),
            '/thisweek': (context) => Thisweek(),
            '/map': (context) => MdhMap(),
            '/settings': (context) => Settings(),
          },
      ),
    );
  }
}