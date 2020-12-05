import 'package:flutter/material.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:stacked_themes/stacked_themes.dart';

class Thisweek extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('This Week')),
      ),
      body: Container(
        child: RaisedButton(
          child: Text("Change Theme"),
          onPressed: () {
            getThemeManager(context).toggleDarkLightTheme();
          },
        ),
      ),
      bottomNavigationBar: NaviagtionBarLoggedIn(),
    );
  }
}
