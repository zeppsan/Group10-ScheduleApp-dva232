import 'dart:ui';

class Note{
  final String id;
  final String title;
  final String content;
  final String courseCode;
  final DateTime date;
  final String noteText;
  final Color color;
  bool expired = false;

  Note({this.title, this.content, this.courseCode, this.date, this.id, this.noteText, this.color});
}