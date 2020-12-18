import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'registerForm.dart';
import 'loginForm.dart';

class LoginMain extends StatefulWidget {
  static bool darkTheme;

  @override
  _LoginMainState createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  bool _login;
  bool _register;
  bool _darkTheme;

  //DarkTheme Colors
  var _logoDark = Color(0xffeeb462);
  var _gradientStartDark = Color(0xff2c1d33);
  var _gradientEndDark = Colors.black;

  //Light Theme Colors
  var _logoLight = Color(0xff2c1d33);
  var _gradientStartLight = Color(0xffeeb462);
  var _gradientEndLight = Color(0xFFFFFFFF);

  @override
  void initState() {
    _login = true;
    _register = false;
    _darkTheme = LoginMain.darkTheme;
    checkLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: body(),
    );
  }

  Widget body() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _darkTheme ? _gradientStartDark : _gradientStartLight,
                _darkTheme ? _gradientEndDark : _gradientEndLight]
          )
      ),
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  child: Text(
                    "MaShRoom",
                    style: TextStyle(
                        fontSize: 36.0,
                        color: _darkTheme ? _logoDark : _logoLight),
                  ),
                  padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 100.0),
                ),
                Visibility(
                  child: AnimatedOpacity(
                    child: LoginForm(),
                    opacity: _login ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 10000),
                  ),
                  visible: _login,
                ),
                Visibility(
                  child: AnimatedOpacity(
                    child: RegisterForm(),
                    opacity: _register ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 10000),
                  ),
                  visible: _register,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(MediaQuery.of(context).size.width, 50.0),
                  ),
                  child: Text(_login ? "Register" : "Back to login",
                      textAlign: TextAlign.center),
                  onPressed: () {
                    setState(() {
                      _login = !_login;
                      _register = !_register;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void checkLogin(context) async {
    var url = 'https://qvarnstrom.tech/api/auth/refresh';

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('token');
    print("StoredToken: $token");

    //Token = null then the user haven't logged in
    if (token == null) {
      return;
    }

    print("Refresh token");

    var response = await http.post(url, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ' + token,
      "Accept": "application/json"
    });

    print("HTTP.post return ${response.body}");

    //The token is not valid. Need to update
    if (response.statusCode == 401) {
      print("CheckLogin status 401");
      //If the user has ticked the remember box get the email and password
      if (localStorage.getString('email') != null) {
        var newLogin = 'https://qvarnstrom.tech/api/auth/login';
        String email = await localStorage.getString('email');
        String password = await localStorage.getString('password');

        Map data = {
          'email': '$email',
          'password': '$password',
        };

        var body = json.encode(data);

        //Fake the login and get the an new token.
        print("Fake login");
        var responseNewLogin = await http.post(newLogin,
            headers: {"Content-Type": "application/json"}, body: body);

        if (responseNewLogin.statusCode == 200) {
          Map responseData = jsonDecode(responseNewLogin.body);
          localStorage.setString('token', responseData['access_token']);
        }

        Navigator.pushReplacementNamed(context, "/thisweek");
      }
    }
    //The old token was valid and have now been updated
    else if (response.statusCode == 200) {
      print("CheckLogin status 200");
      Map responseData = jsonDecode(response.body);

      localStorage.setString('token', responseData['access_token']);
      Navigator.pushReplacementNamed(context, "/thisweek");
    }
  }
}
