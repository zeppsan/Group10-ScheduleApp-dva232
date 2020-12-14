import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_dva232/map/presentation/pages/browsing_page.dart';
import 'package:schedule_dva232/map/presentation/pages/intro_map_page.dart';
import 'package:schedule_dva232/map/presentation/pages/searching_page.dart';

class Router {
  static Route<dynamic> generateRoute (RouteSettings settings) {
    final args = settings.arguments;

    switch(settings.name) {
      case '/':
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
      default:
        return MaterialPageRoute (builder: (_)=> IntroMapPage());
    }
  }
}