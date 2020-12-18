import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:schedule_dva232/schedule/subfiles/CourseParser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:schedule_dva232/generalPages/settings.dart';

var prevDay =1;
bool lightTheme = true;
Random rand = new Random();


class Thisweek extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('This Week'),
      ),
      endDrawer: Settings(),
      body: Container(
        child: fiveTopDays(),
      ),
      bottomNavigationBar: NavigationBarLoggedIn(),
    );
  }
}

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
    _checkSchedule = checkSchedule(); //get Future<Map<DateTime, List<Lecture>>> events from CourseParser
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _checkSchedule,
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (!snapshot.hasData || snapshot.data.toString() == "{}") { //if no data in map or has no data show nothing
                return  Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("There is not an active course schedule for you.",
                              style: TextStyle(fontSize: 20,
                                  color: lightTheme ? Color(0xff2c1d33) : Color(0xffeeb462)),
                              textAlign: TextAlign.center,
                            ),
                            Container(height: 70,),
                            Text("Either do nothing or add one",
                              style: TextStyle(fontSize: 20,
                                  color: lightTheme ? Color(0xff2c1d33) : Color(0xffeeb462)),
                              textAlign: TextAlign.center,
                            ),
                            Container(height: 20,),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(" "+getday(pos)+"  "+getDayDate(pos).toString()+"/"+DateTime.now().month.toString(), //KOMMER EJ FUNGERA VID MÅNADSSKIFTE NY FUNKTION GET MONTH!!
                            style: TextStyle(fontSize: 20, color: lightTheme ? Color(0xff2c1d33) : Color(0xffeeb462), fontWeight: FontWeight.bold),
                          ),
                          Container(
                            child: Builder(
                              builder: (context) {
                                if (_selectedLectures != null) { // if there is data in map == you have lectures
                                  return Column(
                                    children: _selectedLectures.map((e) {
                                      return Card(
                                        elevation: 5,
                                        shadowColor: lightTheme ? Color(0xff2c1d33): Colors.grey, //CHECK WITH SCHEDULE WHAT COLORS!!
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10), //MAKE THIS WORK!!
                                        ),
                                        color: e.color,
                                        child: ListTile(
                                          leading: Text(e.getTime(e.startTime) + "\n    -\n" + e.getTime(e.endTime),
                                              style: TextStyle(fontSize: 15, color: Color(0xff2c1d33))
                                          ),
                                          title: Text(e.course_code.toUpperCase(),
                                              style: TextStyle(color: Color(0xff2c1d33),)),
                                          subtitle: Text(e.moment,
                                            style: TextStyle(fontSize: 15, color: Color(0xff2c1d33)),),
                                          trailing: FlatButton(
                                            child: Text(e.location.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Color(0xff2c1d33),
                                                  decoration: TextDecoration.underline,
                                                  decorationThickness: 1.5,)
                                            ),
                                            onPressed: () {
                                              Navigator.pushNamed((context), '/searching', arguments: e.location.toLowerCase());
                                            },
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }
                                else { //If there isnt lectures for that day print random message! BUG RANDOMIZE EVERYTIME YOU RELODE THE PAGE....
                                  var text;
                                  switch(rand.nextInt(10)){
                                    case 0:
                                      text = "There is nothing here.\n Have fun!";
                                      break;
                                    case 1:
                                      text = "Everything but grade 3 is a luxury\n Please go do something else!";
                                      break;
                                    case 2:
                                      text = "No classes today.\n Maybe you should do some homework.";
                                      break;
                                    case 3:
                                      text = "There is always retakes..\n maybe this is a sign to partaay";
                                      break;
                                    case 4:
                                      text = "Seems like there are no classes today.\n Lucky you!";
                                      break;
                                    case 5:
                                      text = "There is always retakes..\n but it's always nice to pass the first exam";
                                      break;
                                    case 6:
                                      text = "Finally! No classes!\n What to do know?";
                                      break;
                                    case 7:
                                      text = "Today's schedule is  empty.\n This is the day to focus on you!";
                                      break;
                                    case 8:
                                      text = "You seem to be free from school today.\n Maybe you should contact your friends!";
                                      break;
                                    case 9:
                                      text = "A day with no classes?\n But there is always something to do... Hit the books!";
                                      break;
                                  }
                                  return Text(" "+text,//maybe add \n
                                    style: TextStyle(color: lightTheme ? Color(0xff2c1d33) : Color(0xffeeb462), fontSize: 17, ),
                                      textAlign: TextAlign.left,
                                  );
                                }
                              },
                            ),
                          ),
                          Container(height: 40,),
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
/*
Future<Map<DateTime, List<Lecture>>> checkSchedule(context) async{
  //SharedPreferences localStorage = await SharedPreferences.getInstance();
  Map<DateTime, List<Lecture>> result;
  Future nogotfint = ScheduleUpdater.getEvents(context);
  await nogotfint.whenComplete(() async{
    CourseParser parser = CourseParser(rawData: jsonDecode(localStorage.getString('rawSchedule')));
    await parser.parseRawData();
    result = parser.events;
  });
  return result;
}*/

String getday(int loopPos) {
  var daynr = DateTime.now().weekday +loopPos;
  if (daynr == DateTime.now().weekday && daynr < 5)
    return "Today";
  if (daynr >5 )  {
    for(int i = daynr-5; i<=daynr-5;  i++){
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
  var actualDay = DateTime.now().day + loopPos;// inte över 30

  if (DateTime(DateTime.now().year, DateTime.now().month,actualDay).weekday>5)  { //Om helg eller om dagen i loopen innan är större än idag....
    actualDay = actualDay+2;
  }
  if( prevDay > actualDay && loopPos>1)
    actualDay +=2;

  prevDay = actualDay;

  return actualDay;
}