import 'package:flutter/material.dart';
import 'package:schedule_dva232/routing.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:schedule_dva232/theme/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedule_dva232/injection_container.dart' as ic;
import 'package:workmanager/workmanager.dart';

import 'notification/notificationHandler.dart';

var theme;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager.registerPeriodicTask('2', 'simpelPeriodTask', frequency: Duration(minutes: 15));
  await ic.init();
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
       onGenerateRoute: Roots.generateRoute,
      ),
    );
  }
}
