import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_dva232/routing.dart';
import 'package:schedule_dva232/schedule/subfiles/scheduleUpdater.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:schedule_dva232/theme/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedule_dva232/injection_container.dart' as ic;
import 'package:workmanager/workmanager.dart';
import 'package:cron/cron.dart';
import 'package:schedule_dva232/globalNotification.dart' as global;

import 'notification/notificationHandler.dart';
import 'notification/updateCheck.dart';

var theme;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();


  var cron = new Cron();
  cron.schedule(Schedule.parse('* * * * *'), () async { // '0 * * * *' schedule update checks once every hour
    parseSchedule();
    print(global.newItem);
    Future.delayed(Duration(seconds: 1), () async{
      if(global.newItem){
        global.notificationList.forEach((element) {
          print('testar loopa listan');
          Future.delayed(Duration(seconds: 2), (){
            Workmanager.initialize(callbackDispatcher, isInDebugMode: false); //debugMode is only to help with debugging
            Workmanager.registerOneOffTask('1', 'simpelTask', inputData: {'string': '${element.content}'
            });
         });
        });
      }
    });

  });


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
    return ThemeBuilder(
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
