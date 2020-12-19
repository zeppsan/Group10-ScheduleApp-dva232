import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:schedule_dva232/schedule/subfiles/colorPicker.dart';
import 'package:schedule_dva232/schedule/thisweek.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'subfiles/colorPicker.dart';
import 'package:schedule_dva232/generalPages/settings.dart';

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
  bool loadingSpinner;
  Map<String, Color> course_initColors;

  /*
  * COLORS SETTINGS
  * */
  final Color trashbinColor = Colors.grey[800];
  final Color courseCodeColor = Colors.grey[800];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    course_input = TextEditingController();
    courseFuture = getCourseList();
    activeButton = true;
    course_initColors = Map<String, Color>();
    loadingSpinner = false;
  }

  @override
  Widget build(BuildContext context) {
    getCourseColors();
    return Scaffold(
      appBar: AppBar(
        title: Text("Course Information"),
        actions: [
          Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.more_vert_outlined),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              }
          ),
        ],
        //OLD
        /*actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/scheduleSettings');
              },
            icon: Icon(
            Icons.notifications_none_rounded,
            color:  const Color(0xffdfb15b),
            ),
          ),
        ],*/
      ),
      endDrawer: Settings(),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(15, 40, 15, 10),
              child: TextField(
                controller: course_input,
                decoration: InputDecoration(
                  hintText: 'Course Code',
                  hintStyle: TextStyle(fontWeight: FontWeight.bold,
                      color: lightTheme ? const Color(0xff2c1d33) : const Color(
                          0xffeeb462)),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      loadingSpinner = true;
                    });
                    if (activeButton) {
                      activeButton = false;
                      addToList = addCourseToList(course_input.text);
                      FocusScope.of(context).unfocus();
                    }

                    addToList.whenComplete(() => {
                          setState(() {
                            loadingSpinner = false;
                            courseFuture = getCourseList();
                          })
                        });
                  },
                  child: Text("Add course")),
            ),
            (loadingSpinner)?CircularProgressIndicator():SizedBox(),
            Flexible(
              child: FutureBuilder(
                future: courseFuture,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
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
                                      Container(child: Text("${e}".toUpperCase(), style: TextStyle(color: courseCodeColor),)),
                                      Expanded(
                                        child: BarColorPicker(
                                          cornerRadius: 10,
                                          colorListener: (int value) {
                                            currentColor.value = Color(value);
                                            setCourseColor(e, currentColor.value);
                                            print("I did set the color ${value}");
                                          },
                                          thumbColor: Colors.white,
                                          initialColor: (course_initColors[e] != null)? course_initColors[e] : Colors.lightBlueAccent,
                                        ),
                                      ),
                                    ]),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      color: trashbinColor,
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
                      return SizedBox();
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
