import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'registerForm.dart';
import 'loginForm.dart';

class LoginMain extends StatefulWidget {
  @override
  _LoginMainState createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  bool _login;
  bool _register;

  @override
  void initState (){
    _login = true;
    _register = false;
    checkLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    final appTitle = 'XonorK';

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: body(),
    );
  }

  Widget body(){
    return ListView(
      children: [ Container(
        padding: EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              child: LoginForm(),
              visible: _login,
            ),
            Visibility(
              child: RegisterForm(),
              visible: _register,
            ),
            Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(30.0),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () {
                  setState(() {
                    _login = !_login;
                    _register = !_register;
                  });
                },
                child: Text(_login ? "Register" : "Login", textAlign: TextAlign.center,),
              ),
            ),
          ],
        ),
      ),
      ],
    );
  }

  void checkLogin (context) async{
    var url = 'https://qvarnstrom.tech/api/auth/refresh';

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String token = localStorage.getString('token');
    print("StoredToken: $token");

    //Token = null then the user haven't logged in
    if(token == null){
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
    if(response.statusCode == 401) {
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
    else if(response.statusCode == 200){
      print("CheckLogin status 200");
      Map responseData = jsonDecode(response.body);

      localStorage.setString('token', responseData['access_token']);
      Navigator.pushReplacementNamed(context, "/thisweek");
    }
  }
}

