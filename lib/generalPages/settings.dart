import 'package:flutter/material.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_themes/stacked_themes.dart';
import '../appComponents/bottomNavigationLoggedIn.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      bottomNavigationBar: NavigationBarLoggedIn(),
      body: Column(
        children: [
          FlatButton.icon(
              onPressed: () async {
                SharedPreferences key = await SharedPreferences.getInstance();
                await key.remove('token');
                Navigator.pushReplacementNamed(context, '/');
              },
              icon: Icon(Icons.sensor_door_outlined),
              label: Text('Logout'),
          ),
          ElevatedButton(
            child: Text("Change Theme"),
            onPressed: () {
              getThemeManager(context).toggleDarkLightTheme();
            },
          ),
          FlatButton.icon(
              onPressed: () async {
                SharedPreferences localStorage = await SharedPreferences.getInstance();
                await localStorage.remove('rawSchedule');
                await localStorage.remove('token');
                await localStorage.remove('course_list');
                Navigator.pushReplacementNamed(context, '/');
              },
              icon: Icon(Icons.remove_circle),
              label: Text('Remove User Localstorage (temp)'),
          ),
          ElevatedButton(
            child: Text("Return to main, without signing out"),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
    );
  }
}
