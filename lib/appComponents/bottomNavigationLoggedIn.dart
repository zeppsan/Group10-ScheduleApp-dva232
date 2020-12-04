import 'package:flutter/material.dart';


class NaviagtionBarLoggedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(

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
      ],
      onTap: (value){
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
        }
      },
    );
  }
}
