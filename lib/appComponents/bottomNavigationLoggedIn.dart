import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationBarLoggedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
var _selectedItem = 0;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedItem,
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
           _selectedItem = value;
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/schedule');
            _selectedItem = value;
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/map');
            _selectedItem = value;
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/settings');
            _selectedItem = value;
            break;
        }
      },
    );
  }

}
