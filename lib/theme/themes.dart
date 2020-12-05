import 'package:flutter/material.dart';

class AppTheme{
  AppTheme._();
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.blue,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.white60,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(color: Colors.white,),
      subtitle2: TextStyle(color: Colors.white60),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.blue,
      selectedIconTheme: IconThemeData(color: Colors.white),
      selectedLabelStyle: TextStyle(color:Colors.white),
      unselectedIconTheme: IconThemeData(color: Colors.white60),
      unselectedLabelStyle: TextStyle(color: Colors.white60),
    )
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black12,
    appBarTheme: AppBarTheme(
      color: Colors.black38,
      iconTheme: IconThemeData(
        color: Colors.blue,
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.blueAccent,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(color: Colors.blue,),
      subtitle2: TextStyle(color: Colors.blueAccent),
    ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black38,
        selectedIconTheme: IconThemeData(color: Colors.blue[900]),
        selectedLabelStyle: TextStyle(color:Colors.indigo),
        unselectedIconTheme: IconThemeData(color: Colors.blue),
        unselectedLabelStyle: TextStyle(color: Colors.indigo[900])
      )
  );
}