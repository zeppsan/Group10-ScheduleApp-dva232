import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register.dart';
import 'login.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final appTitle = 'XonorK';
    checkLogin(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: body(),
    );
  }

  Widget body(){
    return Container(
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
    );
  }

  void checkLogin (context) async{
    SharedPreferences key = await SharedPreferences.getInstance();
    key.getString('token');
    print(key.getString('token'));
    if(key.getString('token') != null)
    {
      Navigator.pushReplacementNamed(context, '/thisweek');
    }
  }
}

