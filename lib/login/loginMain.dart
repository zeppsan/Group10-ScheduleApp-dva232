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
  String _switchButton;

  @override
  void initState (){
    _login = true;
    _register = false;
    _switchButton = "Register";
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
    return Column(
      children: [
        Visibility(
          child: LoginForm(),
          visible: _login,
        ),
        Visibility(
          child: RegisterForm(),
          visible: _register,
        ),
        ElevatedButton(
          child: Text("Swap reg/login form"),
          onPressed: (){
            setState(() {
              _login = !_login;
              _register = !_register;
            });
          },
        )
      ],
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

