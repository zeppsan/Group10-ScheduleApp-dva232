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
      bottomNavigationBar: NaviagtionBarLoggedIn(),
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
          RaisedButton(
            child: Text("Change Theme"),
            onPressed: () {
              getThemeManager(context).toggleDarkLightTheme();
            },
          ),
        ],
      ),
    );
  }
}
