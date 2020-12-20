import 'package:http/http.dart' as http;
import 'package:schedule_dva232/schedule/subfiles/CourseParser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

/*
*
* Eric Qvarnström
*
* */


class ScheduleUpdater{


  /*
  *
  * Function updates the schedule if the schedule needs to be updated.
  * This will be run in everytime someone visist schedule or daily
  *
  * */
  static Future<List<dynamic>> getEvents(context) async {

    bool needsUpdate = false;

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    bool hasInternetAccess = true;
    // Checks if the user has internet or not
    try {
      final internetCheck = await InternetAddress.lookup('google.com');
      if (!internetCheck.isNotEmpty && !internetCheck[0].rawAddress.isNotEmpty) {
        // Phone does have internet access
        hasInternetAccess = true;
      }
    } on SocketException catch (_) {
      // Phone does not have internet access
      hasInternetAccess = false;
    }

    // Check if the user is logged in to an account that has online-sync
    if(hasInternetAccess){
      if (localStorage.containsKey('token')) {
        String token = await localStorage.getString('token');
        String url = "https://qvarnstrom.tech/api/schedule/update-check";
        var response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + token,
          },
        );
        if (response.statusCode == 401) {
          /* THE USERS HAS AN INVALID KEY, SEND TO LOGIN SCREEN TO FETCH A NEW ONE. */
          localStorage.remove('token');
          Navigator.pushReplacementNamed(context, '/');
        }

        /* RESPONSECODE 204 == NO UPDATE IS AVALIBLE */
        if(response.statusCode == 204){

          /* CHECK SO THAT A LOCAL COPY EXISTS, ELSE, DOWNLOAD */
          if(!localStorage.containsKey('rawSchedule')){
            /* NO SCHEDULE EXISTS. DOWNLOAD IT (SET BOOL AND PROCESS FURTHER DOWN)*/
            needsUpdate = true;
          } else {
            /* A LOCAL SCHEDULE EXISTS. RETURN THAT ONE */
            return jsonDecode(localStorage.getString('rawSchedule'));
          }
        } else {
          /* SERVER FOUND AN UPDATE, DOWNLOAD IT. PROCESS FURTHER DOWN */
          needsUpdate = true;
        }

        if(needsUpdate){
          String token = await localStorage.getString('token');
          String url = "https://qvarnstrom.tech/api/schedule/update";
          var response = await http.get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ' + token,
            },
          );
          await localStorage.setString('rawSchedule', response.body);
          return jsonDecode(response.body);
        }
      } else {
        /* THE USER IS NOT LOGGED IN */

        /* CHECK IF THERE IS ANY COURSES ADDED TO THE USERS COURSE_LIST */
        if (localStorage.containsKey('course_list')) {

          String courses = localStorage.getString('course_list');
          var url = 'https://qvarnstrom.tech/api/schedule/updateNonUser';

          Map data = {'course_list': localStorage.getString('course_list')};

          //encode Map to JSON
          var body = json.encode(data);

          var response = await http.post(url,
              headers: {"Content-Type": "application/json"}, body: body);
          if (response.statusCode == 200) {
            await localStorage.setString('rawSchedule', response.body);
            return jsonDecode(response.body);
          } else {
            /* THERE ARE NO COURSES TO DOWNLOAD */
            return null;
          }
        } else {
          /* THERE ARE COURSES IN THE COURSE_LIST. DOWNLOAD THEM AND USE THEM! */

          var url = 'https://qvarnstrom.tech/api/schedule/updateNonUser';
          Map data = {'course_list': localStorage.getString('course_list')};
          var body = json.encode(data);
          var response = await http.post(url,
              headers: {"Content-Type": "application/json"}, body: body);

          if (response.statusCode == 200) {
            /* IF THE DATA WAS SUCCESSFULLY DOWNLOADED */
            await localStorage.setString('rawSchedule', response.body);
            return jsonDecode(response.body);
          } else {
            /* IF THE DATA WAS NOT DOWNLOADED CORRECTLY */
            return null;
          }
        }
      }
    } else {
      /*
      *   USER HAVE NO INTERNET CONNECTION
      */
      /* THE ONLY THING TO DO IS TO RETURN THE LOCALLY STORED SCHEDULE IF THERE IS ANY... */
      if(localStorage.containsKey('rawSchedule')){
        return jsonDecode(localStorage.getString('rawSchedule'));
      } else {
        return null;
      }
    }
  }

}