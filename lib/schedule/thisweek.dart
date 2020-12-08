import 'package:flutter/material.dart';
import 'package:schedule_dva232/appComponents/bottomNavigationLoggedIn.dart';

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
// show next 3 upcoming days, today tomorrow {monday, tuesday, wednesday, thursday, friday} depending on what day is the third.
// set up the cards in 3 different rows, for each day, make each row container scrollable so you can scroll through each day
// of cards in separate lists of cards for each day.

class fiveTopDays extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _fiveTopDaysState();
}
//var day = DateFormat('EEEE').format(DateTime.now());


class _fiveTopDaysState extends State<fiveTopDays>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, pos) {
          var daynr = DateTime.now().weekday;
          var day;
          var calcday = daynr + pos;
          if (calcday == 6)
            calcday = pos - daynr - 1;

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
          };
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
      );
    },
        ),

    );
  }
}