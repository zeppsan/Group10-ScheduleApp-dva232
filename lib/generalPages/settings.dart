import 'package:flutter/material.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:schedule_dva232/login/loginMain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_themes/stacked_themes.dart';
import '../appComponents/bottomNavigationLoggedIn.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<bool> _loggedIn;
  bool _darkMode = false;

  @override
  void initState() {
    _loggedIn = checkLogin();
    _darkMode = LoginMain.darkTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      bottomNavigationBar: NavigationBarLoggedIn(),
      body: Column(
        children: [
          FutureBuilder(
            //Will change the button label depending on if the user is logged in or not
            future: _loggedIn,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Something went wrong');
                  break;
                case ConnectionState.active:
                  return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: CircularProgressIndicator()));
                  break;
                case ConnectionState.done:
                  if (snapshot.data == true) {
                    return ElevatedButton(
                        child: Text("Logout"),
                        onPressed: () async {
                          //Reset the stored schedule, token and loggedIn bool
                          SharedPreferences localStorage = await SharedPreferences.getInstance();
                          await localStorage.remove('token');
                          await localStorage.remove('rawSchedule');
                          await localStorage.setBool('loggedIn', false);
                          //Push to home screen
                          Navigator.pushReplacementNamed(context, '/');
                        },
                    );
                  } else {
                    return 
                      Column(
                      children: [
                        SizedBox(height: 10.0,),
                        ElevatedButton(
                          child: Text("Login"),
                          onPressed: () {
                            //Push to home screen
                            Navigator.pushReplacementNamed(context, '/');
                          },
                        ),
                        ElevatedButton(
                          child: Text("Register"),
                          onPressed: () {
                            //Push to home screen
                            Navigator.pushReplacementNamed(context, '/');
                          },
                        ),
                      ],
                    );
                  }
                  break;
                default:
                  return Text("Unexpected error");
              }
            },
          ),
          SizedBox(height: 15.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Change Theme"),
              Switch(
                value: _darkMode,
                onChanged: (value) async {
                  SharedPreferences localStorage = await SharedPreferences.getInstance();
                  if(localStorage.getBool('theme')) {
                    //if lightmode when change set to false to get darkmode
                    localStorage.setBool('theme', false);
                  }
                  else {
                    //if darkmode when change set to true to get lightmode
                    localStorage.setBool('theme', true);
                  }

                  getThemeManager(context).toggleDarkLightTheme();

                  setState(() {
                    _darkMode = value;
                  });
                },
                activeColor: Colors.deepPurple,
                activeTrackColor: Colors.black26,
              )
            ],
          ),

          /*******************************************
           * Only for testing
           *******************************************/
          /*SizedBox(
            height: 150.0,
          ),
          Text(
            "Only for testing. Remove",
            style: TextStyle(color: Colors.deepOrange),
          ),
          FlatButton.icon(
            onPressed: () async {
              SharedPreferences localStorage =
                  await SharedPreferences.getInstance();
              await localStorage.remove('rawSchedule');
              await localStorage.remove('token');
              await localStorage.remove('course_list');
              await localStorage.remove('course_color');
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
          )*/
        ],
      ),
    );
  }

  Future<bool> checkLogin() async {
    bool _loggedIn;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    _loggedIn = localStorage.getBool('loggedIn');
    return Future.value(_loggedIn);
  }
}
