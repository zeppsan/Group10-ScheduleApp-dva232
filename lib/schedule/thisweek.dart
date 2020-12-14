import 'dart:convert';
import 'dart:developer';

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
//Make card list for each day cards are lectures or lessons in the schedule for that day.
//Fill in data for each day

class fiveTopDays extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _fiveTopDaysState();
}

class _fiveTopDaysState extends State<fiveTopDays>{
  @override
  Future _checkSchedule;
  CourseParser parser;
  List<dynamic> days;
  List<Lecture> _selectedLectures;
  Future parsed;

  @override
  void initState(){
    super.initState();
    _checkSchedule = checkSchedule();
    _selectedLectures = List<Lecture>();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _checkSchedule, //holds rawSchedule
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Text("Loading..");
            default:
          if (!snapshot.hasData) { //if there is no data return a message and a button to go to add course.
            return Column(
                children: [
                  Text(
                      "There is no schedule for you.. Either do nothing or add one"),
                  ElevatedButton(onPressed: () {Navigator.pushNamed(context, '/scheduleSettings');},
                  child: Text("Add Course"),),
                ]
            );
          }
          else { //if there is data == schedule, you have lectures, this will print for next upcoming 5 school days.
            log(snapshot.data.toString());
            parsed = getParsed(snapshot.data);

            return  ListView.builder(
              itemCount: 5, //getting a list that loops for 5 indexes 0-4
              itemBuilder: (context, pos) {
                return FutureBuilder(
                  future: parsed,
                  builder: (BuildContext context, snapshot) {
                    log(snapshot.data.toString());
                    switch(snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Text("Loading...");
                        break;
                      default:
                        {
                          _selectedLectures = snapshot.data;
                          return Column(
                            children: [
                              Text(
                                getday(pos), style: TextStyle(fontSize: 20),),
                              //writing days mon-friday, today when weekday
                              ListView(
                                  children: _selectedLectures.map((e) {
                                    if(snapshot.hasData)
                                      return Text("No classes today, YIPPIEKAYEEY!");
                                    else{
                                    return Card(
                                      child: ListTile(
                                        leading: Icon(Icons.work_outline),
                                        title: Text("hej"),
                                      ),
                                    );
                                  }}).toList()
                                ),
                              Container(height: 50,),

                              // getting space between loops/next day
                            ],
                          );
                        }
                    }
                  }
                );
              },                                               
            );
          }
        }}
    );
  }

  Future checkSchedule() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if(localStorage.containsKey('rawSchedule'))
      return jsonDecode(localStorage.getString('rawSchedule'));
  }

  Future<Map<DateTime, List<Lecture>>> getParsed(List<dynamic> coursesToParse) async {
    parser = CourseParser(rawData: coursesToParse);

    await parser.parseRawData();

    return parser.events;
  }
}

String getday(int loopPos) {
  var daynr = DateTime.now().weekday +loopPos;
  if (daynr >=6)
    daynr=1 + loopPos;
  if (daynr == DateTime.now().weekday)
    return "Today";

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
  };
}
int getTimeStamp(int loopPos){
  var actualDay = DateTime.now().day + loopPos;

  if(DateTime.now().weekday >= 6 ) //look past weekend
    actualDay +=1;

  log(loopPos.toString());
  log(DateTime.now().year.toString());
  log(DateTime.fromMicrosecondsSinceEpoch(1607948100000 * 1000).day.toString());
  log(DateTime(DateTime.now().year, DateTime.now().month, actualDay).millisecondsSinceEpoch.toString());

  //return  DateTime(DateTime.now().year, DateTime.now().month, actualDay).millisecondsSinceEpoch;
  return actualDay;
}

/*var daynr = DateTime.now().weekday;
                  var day;
                  var calcday = daynr + pos;

                  if(daynr >= 6)
                    calcday = 1;
                  else if (daynr == calcday)
                    day = "Today";
                  else {
                    log(daynr.toString());
                    log(calcday.toString());
                    switch (calcday) {
                    case 1:
                      day = "Monday";
                      break;
                    case 2:
                      day = "Tuesday";
                      break;
                    case 3:
                      day = "Wednesday";
                      break;
                    case 4:
                      day = "Thursday";
                      break;
                    case 5:
                      day = "Friday";
                      break;
                    case 6:
                      day = "Monday";
                      break;
                    case 7:
                      day = "Tuesday";
                      break;
                    case 8:
                      day = "Wednesday";
                      break;
                    case 9:
                      day = "Thursday";
                      break;
                    };
                  }
                  return Column(children: [
                    Text(day, style: TextStyle(
                      fontSize: 20,
                    ),),
                    SizedBox(
                      height: 150,
                      width: 300,
                      child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, pos) {
                            return Card(
                              child: ListTile(
                                title: Text("hej $pos"),
                                subtitle: Text("undertext $pos"),
                                leading: Icon(Icons.work),
                              ),
                            );
                          }
                      ),
                    ),
                    Container(height: 50,),
                  ],
                  );*/
