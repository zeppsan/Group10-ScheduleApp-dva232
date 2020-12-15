import 'package:flutter/material.dart';
import 'package:schedule_dva232/login/loginMain.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();

}

class _LoadingState extends State<Loading> {
  void getTheme() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    //LightMode
    if(localStorage.getBool('theme')) {
      LoginMain.darkTheme = false;
    }
    //Darkmode
    else if(!(localStorage.getBool('theme'))) {
      LoginMain.darkTheme = true;
    }
    //Just in case the variable is missing in local storage
    //LightMode as default
    else{
      LoginMain.darkTheme = false;
    }

    print("Darkmode variable ${LoginMain.darkTheme}");
    Navigator.pushReplacementNamed(context, '/login');
  }


  @override
  Widget build(BuildContext context) {
    getTheme();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10.0),
            Text("Loading"),
          ],
        ),
      ),
    );
  }
}