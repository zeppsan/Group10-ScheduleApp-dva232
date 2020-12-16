import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:schedule_dva232/schedule/CourseParser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CourseParser.dart';

class Thisweek extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('This Week')),
      ),
      body: Container(
        child: fiveTopDays(),
      ),
      bottomNavigationBar: NavigationBarLoggedIn(),
    );
  }
}

bool lightTheme = true;

class fiveTopDays extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _fiveTopDaysState();
}

class _fiveTopDaysState extends State<fiveTopDays> {
  @override
  Future _checkSchedule;

  @override
  void initState() {
    super.initState();
    _checkSchedule = checkSchedule(); //get rawschedule
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _checkSchedule, //holds rawSchedule
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text("Loading..", style: TextStyle(fontSize: 20,
                  color: lightTheme ? Color(0xff2c1d33) : Colors.white));
            default:
              if (!snapshot.hasData) { //if no data == no schedule get button to addCourse
                return Container(
                  padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
                  child: Column(
                      children: [
                        Text("There is not an active course schedule for you.\n\n\n\nEither do nothing or add one",
                          style: TextStyle(fontSize: 20,
                              color: lightTheme ? Color(0xff2c1d33) : Color(0xffeeb462)),
                          textAlign: TextAlign.center,
                        ),
                        ElevatedButton(
                          child: Text("Add Course", style: TextStyle(fontSize: 20),),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/scheduleSettings');
                          },

                        ),
                      ]
                  ),
                );
              }
              else { //if there is data == schedule, you have lectures, this will print for next upcoming 5 school days.
                return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, pos) {
                      List<Lecture> _selectedLectures = snapshot.data[DateTime(DateTime.now().year, DateTime.now().month, getDayDate(pos))]; //get lectures for specific date
                      return Column(
                        children: <Widget>[
                          Text(getday(pos), style: TextStyle(fontSize: 20, color: lightTheme ? Color(0xff2c1d33) : Color(0xffeeb462)),),

                          Center(
                            child: Builder(
                              builder: (context) {
                                if (_selectedLectures != null) {
                                  return Column(
                                    children: _selectedLectures.map((e) {
                                      return Card(
                                        elevation: 10,
                                        shadowColor: Color(0xff2c1d33),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: ListTile(
                                          leading: Text(e.getTime(e.startTime) + "\n    -\n" + e.getTime(e.endTime),
                                              style: TextStyle(fontSize: 15, color: Colors.white)
                                          ),
                                          title: Text(e.course_code.toUpperCase(),
                                              style: TextStyle(color: Colors.white)),
                                          subtitle: Text(e.moment,
                                            style: TextStyle(fontSize: 15, color: Colors.white),),
                                          trailing: FlatButton(
                                            child: Text(e.location.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  decoration: TextDecoration.underline,
                                                  decorationThickness: 1.5,)
                                            ),
                                            onPressed: () {
                                              Navigator.pushNamed((context), '/searching', arguments: e.location.toLowerCase());
                                            },
                                          ),
                                          tileColor: e.color,
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }
                                else {
                                  return Text("There is nothing here for you, have fun!",
                                    style: TextStyle(color: lightTheme ? Color(0xff2c1d33) : Color(0xffeeb462), fontSize: 17),
                                  );
                                }
                              },
                            ),
                          ),
                          Container(height: 30,),
                        ],
                      );
                    }
                );
              }
          }
        }
    );
  }
}

Future<Map<DateTime, List<Lecture>>> checkSchedule() async{
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  lightTheme = await localStorage.getBool('theme');
  if(localStorage.containsKey('rawSchedule')) {
    CourseParser parser = CourseParser(rawData: jsonDecode(localStorage.getString('rawSchedule')));
    await parser.parseRawData();
    return parser.events;
  }
}

String getday(int loopPos) {
  var daynr = DateTime.now().weekday +loopPos;
  if (daynr == DateTime.now().weekday)
    return "Today";
  if (daynr >5 )  { //kanske fungerar får kolla imorgon
    for(int i = daynr-5; i<=daynr-5;  i++){
      //daynr= daynr-loopPos-i;
          daynr=i;
    }
  }

  switch(daynr){
    case 1:
      return "Monday";
      break;
    case 2:
      return "Tuesday";
      break;
    case 3:
      return "Wednesday";
      break;
    case 4:
      return "Thursday";
      break;
    case 5:
      return  "Friday";
      break;
  }
}

int getDayDate(int loopPos){
  var actualDay = DateTime.now().day + loopPos;
  if (DateTime(DateTime.now().year, DateTime.now().month,actualDay).weekday>5 )  { //kanske fungerar får kolla imorgon om det är helg öka dagens datum med 2 kommer fucka för mer än mån-tis
      actualDay = actualDay+2;
  }
  return actualDay;
}
