import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';
import 'package:schedule_dva232/appComponents/topMenu.dart';
import 'package:schedule_dva232/notification/notifications.dart';
import 'package:schedule_dva232/schedule/subfiles/CourseParser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:schedule_dva232/generalPages/settings.dart';
import 'package:schedule_dva232/schedule/subfiles/scheduleUpdater.dart';


Random rand = new Random();
bool lightTheme = true;

class Thisweek extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title:  Text('This Week',style: TextStyle(fontFamily: "Roboto")),
        actions: [
          NotificationPage(appBarSize: AppBar().preferredSize.height),
          TopMenu(),
          ],
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
  Future _scheduleFetcher;

  @override
  void initState() {
    super.initState();
    _scheduleFetcher = fetchNewSchedule(context);
  }

  Widget build(BuildContext context) {

    // This future waits until the shcedule-update-check is done.
    return FutureBuilder(
      future: _scheduleFetcher,
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.done:
            _checkSchedule = checkSchedule(context);

            // This future waits for the page to fetch the updated value from the localStorage.
            return FutureBuilder(
                future: _checkSchedule,
                builder: (BuildContext context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
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
                              List<Lecture> _selectedLectures = snapshot.data[DateTime(DateTime.now().year, DateTime.now().month, getDayLecture(pos))]; //get lectures for specific date
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(height: 15,),

                                  Text(" "+getday(pos)+" "+getDayDate(pos),
                                    style: TextStyle(fontSize: 20, color: lightTheme ? Color(0xff2c1d33) : Color(0xffeeb462), fontWeight: FontWeight.bold, wordSpacing: 10.0),
                                    //textAlign: TextAlign.start,
                                  ),

                                  Container(
                                    child: Builder(
                                      builder: (context) {
                                        if (_selectedLectures != null) { // if there is data in map == you have lectures
                                          return Column(
                                            children: _selectedLectures.map((e) {
                                              return Card(
                                                elevation: 5,
                                                shadowColor: Color(0xff2c1d33), //glow->//lightTheme ? Color(0xff2c1d33): Colors.grey, //CHECK WITH SCHEDULE WHAT COLORS!!
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
                                                      if (e.location == "zoom")
                                                        print("zoom");
                                                      else
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
                                              text = "There is nothing here.\nHave fun!";
                                              break;
                                            case 1:
                                              text = "Everything but grade 3 is a luxury\nPlease go do something else!";
                                              break;
                                            case 2:
                                              text = "No classes today.\nMaybe you should do some homework.";
                                              break;
                                            case 3:
                                              text = "There is always retakes..\nmaybe this is a sign to partaay";
                                              break;
                                            case 4:
                                              text = "Seems like there are no classes today.\nLucky you!";
                                              break;
                                            case 5:
                                              text = "There is always retakes..\nbut it's always nice to pass the first exam";
                                              break;
                                            case 6:
                                              text = "Finally! No classes!\nWhat to do now?";
                                              break;
                                            case 7:
                                              text = "Today's schedule is  empty.\nThis is the day to focus on you!";
                                              break;
                                            case 8:
                                              text = "You seem to be free from school today.\nMaybe you should contact your friends!";
                                              break;
                                            case 9:
                                              text = "A day with no classes?\nBut there is always something to do... Hit the books!";
                                              break;
                                          }
                                          return Card(
                                            elevation: 5,
                                            shadowColor: Color(0xff2c1d33),//glow->//lightTheme ? Color(0xff2c1d33): Colors.grey, //CHECK WITH SCHEDULE WHAT COLORS!!
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10), //MAKE THIS WORK!!
                                            ),
                                            child: ListTile(
                                              title: Text(text,//maybe add \n
                                                style: TextStyle(color: lightTheme ? Color(0xff2c1d33) : Colors.white, fontSize: 17,),
                                                textAlign: TextAlign.left,
                                              ),
                                              trailing: Icon(Icons.emoji_emotions_outlined,size: 30,
                                                color: lightTheme ? Color(0xff2c1d33) : Color(0xffeeb462),),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Container(height: 25,),
                                ],
                              );
                            }
                        );
                      }
                  }
                }
            );
            break;
          default:
            return Center(child:CircularProgressIndicator());
            break;
        }
      },
    );
  }
}

Future<Map<DateTime, List<Lecture>>> checkSchedule(context) async{
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  lightTheme = await localStorage.getBool('theme');

  Map<DateTime, List<Lecture>> result;

  CourseParser parser = CourseParser(rawData: jsonDecode(localStorage.getString('rawSchedule')));
  await parser.parseRawData();
  result = parser.events;

  return result;
}

Future<List<dynamic>> fetchNewSchedule(context)async{
  Future<List<dynamic>> nogotfint = ScheduleUpdater.getEvents(context);
  return nogotfint;
}

String getday(int loopPos) {
  var daynr = DateTime.now().weekday +loopPos;

  if (daynr == DateTime.now().weekday && daynr <6)
    return "Today";

  if (DateTime.now().weekday == 7 )  { //if sunday
    for(int i = daynr-6; i<=daynr-6 ;  i++){
      daynr=i;
    }
  }
  if(daynr>5 && DateTime.now().weekday != 7){
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

String getDayDate(int loopPos){
  var actualDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+loopPos);

  if(DateTime.now().weekday == 7) // if sunday
    actualDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+loopPos+1);
  if(DateTime.now().weekday+loopPos>5  && DateTime.now().weekday != 7)
    actualDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+2+loopPos);

  return "${actualDay.day}/${actualDay.month}";
}

int getDayLecture(int loopPos){
  var actualDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+loopPos);

  if(DateTime.now().weekday == 7) // if sunday
    actualDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+loopPos+1);
  if(DateTime.now().weekday+loopPos>5  && DateTime.now().weekday != 7)
    actualDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+2+loopPos);

  return actualDay.day;
}