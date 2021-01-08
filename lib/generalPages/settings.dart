import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_dva232/login/loginMain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_themes/stacked_themes.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<bool> _loggedIn;
  bool _darkModeSwitch;

  //Colors of the switch when active
  Color _lightActive = Color(0xff2c1d33);
  Color _darkActive = Color(0xffeeb462);

  @override
  void initState() {
    super.initState();
    _loggedIn = checkLogin();
    _darkModeSwitch = LoginMain.darkTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 100.0,
            ),
            Image.asset('assets/logo/LogoBlackBorders.png', width: 120.0, height: 120.0),
            SizedBox(
              height: 30.0,
            ),
            Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Container(
                //color: Colors.amber,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30.0,
                    ),

                    FlatButton(
                      //color: Colors.blue,
                     // minWidth: 150,
                      child: Row(
                        children: [
                          Text("Manage courses", style: TextStyle(fontSize: 16),),
                          Expanded(child: SizedBox()),
                          Icon(
                            Icons.build_rounded,
                            color: _darkModeSwitch ? _darkActive : _lightActive,
                          ),
                        ],

                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/scheduleSettings');
                      },
                    ),


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
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: Center(child: CircularProgressIndicator()));
                            break;
                          case ConnectionState.done:
                            if (snapshot.data == true) {
                              return loggedIn();
                            } else {
                              return notLoggedIn();
                            }
                            break;
                          default:
                            return Text("Unexpected error");
                        }
                      },
                    ),
                    SizedBox(height: 20.0),
                    Divider(thickness: 1,),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text("Light theme", style: TextStyle(fontSize: 15)),
                        Switch(
                          inactiveTrackColor: _darkModeSwitch ? _darkActive : _lightActive,
                          activeColor: _darkModeSwitch ? _darkActive : _lightActive,
                          inactiveThumbColor: _darkModeSwitch ? _darkActive : _lightActive,
                          value: _darkModeSwitch,
                          onChanged: (value) async {
                            SharedPreferences localStorage =
                            await SharedPreferences.getInstance();
                            if (localStorage.getBool('theme')) {
                              //if lightmode when change set to false to get darkmode
                              localStorage.setBool('theme', false);
                            } else {
                              //if darkmode when change set to true to get lightmode
                              localStorage.setBool('theme', true);
                            }
                            //Needed to make the switch select the right theme every time the drawer is used
                            LoginMain.darkTheme = !LoginMain.darkTheme;
                            //Change the theme
                            getThemeManager(context).toggleDarkLightTheme();

                            setState(() {
                              _darkModeSwitch = value;
                            });
                          },
                        ),
                        Text("Dark theme", style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /*******************************************
             * Only for testing
             *******************************************/
          /*  SizedBox(
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
            ),*/
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

  Widget loggedIn() {
    return FlatButton(
      child: Row(
        children: [
          Text("Logout", style: TextStyle(fontSize: 16)),
          Expanded(child: SizedBox()),
          Icon(
            Icons.logout,
            color: _darkModeSwitch ? _darkActive : _lightActive,
          ),
        ],
      ),
      onPressed: () async {
        SharedPreferences localStorage = await SharedPreferences
            .getInstance();
        await localStorage.remove('token');
        await localStorage.remove('rawSchedule');
        await localStorage.setBool('loggedIn', false);
        //Push to home screen
        Navigator.pushReplacementNamed(context, '/');
      },
    );
  }

  Widget notLoggedIn() {
    return FlatButton(
      child: Row(
        children: [
          Text("Login", style: TextStyle(fontSize: 16)),
          Expanded(child: SizedBox()),
          Icon(
            Icons.login,
            color: _darkModeSwitch ? _darkActive : _lightActive,
          ),
        ],
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/');
      },
    );
  }
}
