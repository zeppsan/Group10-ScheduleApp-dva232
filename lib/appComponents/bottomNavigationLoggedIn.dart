import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NaviagtionBarLoggedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'This week',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: 'Schedule',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      onTap: (value) async {
        switch(value){
          case 0:
            Navigator.pushReplacementNamed(context, '/thisweek');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/schedule');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/map');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/settings');
            break;
        }
      },
    );
  }

}
