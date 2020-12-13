import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:schedule_dva232/schedule/colorPicker.dart';

class ScheduleSettings extends StatefulWidget {
  @override
  _ScheduleSettingsState createState() => _ScheduleSettingsState();
}

class _ScheduleSettingsState extends State<ScheduleSettings> {
  @override
  TextEditingController course_input;
  Future courseFuture;
  bool activeButton;
  Future addToList;
  Future<bool> loadingSpinner;
  Map<String, Color> course_initColors;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    course_input = TextEditingController();
    courseFuture = getCourseList();
    activeButton = true;
    course_initColors = Map<String, Color>();
  }

  @override
  Widget build(BuildContext context) {
    getCourseColors();
    return Scaffold(
      appBar: AppBar(
        title: Text("Course Information"),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              margin: EdgeInsets.fromLTRB(15, 40, 15, 10),
              child: TextField(
                controller: course_input,
                decoration: InputDecoration(
                  hintText: 'Course Code',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: ElevatedButton(
                  onPressed: () {
                    if (activeButton) {
                      activeButton = false;
                      addToList = addCourseToList(course_input.text);
                      FocusScope.of(context).unfocus();
                    }
                    addToList.whenComplete(() => {
                          setState(() {
                            courseFuture = getCourseList();
                          })
                        });
                  },
                  child: Text("Add course")),
            ),
            Flexible(
              child: FutureBuilder(
                future: courseFuture,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CircularProgressIndicator();
                      break;
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        List<dynamic> courses = List<dynamic>();
                        courses = snapshot.data;
                        activeButton = true;
                        return ListView(
                            children: courses.map((e) {
                          colorNofitier currentColor = colorNofitier((course_initColors[e] != null)? course_initColors[e] : Colors.lightBlueAccent);
                          return ValueListenableBuilder(
                            valueListenable: currentColor,
                            builder: (context, Color value, child) {
                              return Card(
                                color: currentColor.value,
                                margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
                                child: ListTile(
                                    title: Row(children: [
                                      Text("${e}"),
                                      BarColorPicker(
                                        colorListener: (int value) {
                                          currentColor.value = Color(value + 00000);
                                          setCourseColor(e, currentColor.value);
                                        },
                                        thumbColor: Colors.white,
                                        initialColor: (course_initColors[e] != null)? course_initColors[e] : Colors.lightBlueAccent,
                                      ),
                                    ]),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        removeCourse(e);
                                        Future.delayed(
                                            Duration(milliseconds: 400), () {
                                          setState(() {
                                            courseFuture = getCourseList();
                                          });
                                        });
                                      },
                                    )),
                              );
                            },
                          );
                        }).toList());
                      } else {
                        return Text(
                            "No courses to show :(",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        );
                      }
                      break;
                    default:
                      return Text("WTF");
                      break;
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBarLoggedIn(),
    );
  }

  Future<List<dynamic>> getCourseList() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    // IF THE USER IS LOGGED IN
    if (localStorage.containsKey('token')) {
      String token = await localStorage.getString('token');
      var url = 'https://qvarnstrom.tech/api/schedule/getCourses';
      var response = await http.get(url, headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ' + token,
        "Accept": "application/json"
      });
      print(response.body.toString());
      List<dynamic> result = jsonDecode(response.body);
      return result;
    }

    // IF THE USER IS NOT LOGGED IN
    if (!localStorage.containsKey('course_list')) {
      return null;
    } else {
      List<dynamic> courses =
          await jsonDecode(localStorage.getString('course_list'));
      return courses;
    }
  }

  Future<bool> addCourseToList(String courseName) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    List<dynamic> courses;

    // Check if course exist:
    if (localStorage.containsKey('token')) {
      String token = await localStorage.getString('token');
      // IF THE USER IS LOGGED IN

      var url = 'https://qvarnstrom.tech/api/schedule/add';

      Map data = {'course_code': courseName};

      //encode Map to JSON
      var body = json.encode(data);

      var response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + token,
            "Accept": "application/json"
          },
          body: body);

      if(response.statusCode == 500){
        var test = AlertDialog(
          title: Text('Course ${courseName} does not exist...'),
          actions: [
            FlatButton(
              child: Text('Okay'),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        );
        showDialog(
          context: context,
          builder: (_) => test,
          barrierDismissible: true,
        );
      } else {
        url = 'https://qvarnstrom.tech/api/schedule/update';
        response = await http.get(url, headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ' + token,
          "Accept": "application/json"
        });
        await localStorage.setString('rawSchedule', response.body);
      }
      return true;
    } else {
      // IF THE USER IS NOT LOGGED IN
      var url = 'https://qvarnstrom.tech/api/schedule/exist/${courseName}';
      //encode Map to JSON
      var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        if (localStorage.containsKey('course_list')) {
          courses = jsonDecode(localStorage.getString('course_list'));
          if (courses.contains(courseName)) {
            return true;
          }
        } else {
          courses = List<String>();
        }
        courses.add(courseName);
        localStorage.setString('course_list', jsonEncode(courses));
        log(localStorage.getString('course_list'));
      } else {
        print("Status was : ${response.statusCode}");
        var test = AlertDialog(
          title: Text('Course does not exist...'),
        );
        showDialog(
          context: context,
          builder: (_) => test,
          barrierDismissible: true,
        );
      }
      return true;
    }
  }

  void removeCourse(courseName) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    List<dynamic> courses;

    // Check if course exist:
    if (localStorage.containsKey('token')) {
      // IF THE USER IS LOGGED IN

      String token = await localStorage.getString('token');
      // IF THE USER IS LOGGED IN

      var url = 'https://qvarnstrom.tech/api/schedule/remove';

      Map data = {'course_code': courseName};

      //encode Map to JSON
      var body = json.encode(data);

      var response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ' + token,
            "Accept": "application/json"
          },
          body: body);
      await localStorage.remove('rawSchedule');
    } else {
      courses = jsonDecode(localStorage.getString('course_list'));
      courses.remove(courseName);
      localStorage.setString('course_list', jsonEncode(courses));
    }
  }


  void setCourseColor(String courseName, Color color) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if(!localStorage.containsKey('course_color')){
      Map<dynamic, dynamic> list = new Map<dynamic, dynamic>();
      list[courseName] = color.value.toString();
      localStorage.setString('course_color', jsonEncode(list));
    } else {
      Map<dynamic, dynamic> list = await jsonDecode(localStorage.getString('course_color'));
      list[courseName] = color.value.toString();
      localStorage.setString('course_color', jsonEncode(list));
    }
  }


  void getCourseColors() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    LinkedHashMap fromLocalStorage;

    if(localStorage.containsKey('course_color')){
      fromLocalStorage = jsonDecode(localStorage.getString('course_color'));
      fromLocalStorage.forEach((key, value) {
        course_initColors[key] = Color(int.parse(value));
      });
    }
  }

}

class colorNofitier extends ValueNotifier<Color> {
  colorNofitier(value) : super(value);
}
