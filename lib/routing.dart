import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_dva232/map/presentation/pages/browsing_page.dart';
import 'package:schedule_dva232/map/presentation/pages/intro_map_page.dart';
import 'package:schedule_dva232/map/presentation/pages/searching_page.dart';
import 'package:schedule_dva232/schedule/addCourse.dart';
import 'package:schedule_dva232/schedule/schedule.dart';
import 'package:schedule_dva232/schedule/scheduleSettings.dart';
import 'package:schedule_dva232/schedule/thisweek.dart';

import 'generalPages/settings.dart';
import 'login/loginMain.dart';

/*'/': (context) => LoginMain(),
'/schedule': (context) => Schedule(),
'/scheduleSettings': (context) => ScheduleSettings(),
'/addCourse': (context) => AddCourse(),
'/thisweek': (context) => Thisweek(),
'/map': (context) => IntroMapPage(),
'/browsing': (context) => BrowsingPage(arguments)
'/settings': (context) => Settings(),*/

class Roots {
  static Route<dynamic> generateRoute (RouteSettings settings) {
    final args = settings.arguments;

    switch(settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_)=> LoginMain());
        break;
      case '/schedule':
        return MaterialPageRoute(builder: (_)=> Schedule());
        break;
      case '/scheduleSettings':
        return MaterialPageRoute(builder: (_)=> ScheduleSettings());
        break;
      case '/addCourse':
        return MaterialPageRoute(builder: (_)=> AddCourse());
        break;
      case '/thisweek':
        return MaterialPageRoute(builder: (_)=> Thisweek());
        break;
      case '/map':
        return MaterialPageRoute(builder: (_)=> IntroMapPage());
        break;
      case '/browsing':
        if(args is String) {
          return MaterialPageRoute(
            builder:(_)=> BrowsingPage(
                buildingToFind: args,
            ),
          );
        }
        else return null;
        break;
      case '/searching':
          return MaterialPageRoute(
            builder:(_)=> SearchingPage(
              roomToFind: args,
            ),
          );

        break;
      case '/settings':
        return MaterialPageRoute(builder: (_)=> Settings());
        break;
      default:
        return MaterialPageRoute (builder: (_)=> IntroMapPage());
    }
  }
}