import 'dart:ui';
import '../globalNotification.dart';

/*
*
* Emelie Wallin
*
* */

class Note{
  final String id;
  final String title;
  final String content;
  final String courseCode;
  final DateTime date;
  final String noteText;
  Color color;
  bool expired = false;

  Note({this.title, this.content, this.courseCode, this.date, this.id, this.noteText, this.color});
}

//function to update color of a course in the notificationList
void updateColorNotifications(Color color, String courseCode) {
  if(notificationList != null){
    print(courseCode);

    notificationList.forEach((element) {
      if(element.courseCode == courseCode.toUpperCase()) {
        element.color = color;
      }
    });
  }
}