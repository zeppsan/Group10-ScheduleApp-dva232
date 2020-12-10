import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';

class ScheduleSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule Settings"),
      ),
      body: Container(
        child: FlatButton.icon(
          onPressed:(){Navigator.pushNamed(context, '/addCourse');},
          icon: Icon(Icons.add,color: Colors.orangeAccent,size: 100,),
          label: Text(""),
        ),
        alignment: Alignment.bottomCenter,
      ),
      bottomNavigationBar: NavigationBarLoggedIn(),
    );
  }
}
