import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'register.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Check{

  Future<bool> signedIn() async{
    //Start by assuming the user isnt signed in
    bool signedIn = false;
    print("Init state, check logged");

    //Check if they have an token stored on the phone
    SharedPreferences key = await SharedPreferences.getInstance();
    key.getString('token');
    print(key.getString('token'));
    if(key.getString('token') != null)
    {
      signedIn = true;
    }
    print("Init state, check logged in returns $signedIn");
    return Future.value(signedIn);
}
}