/*
This will work as an CSS file, if you want to change color of buttons
 */
import 'package:flutter/material.dart';

class AppTheme{
  AppTheme._();
  static final ThemeData lightTheme = ThemeData(
    fontFamily: "Handlee",
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,

    appBarTheme: AppBarTheme(
      color: const Color(0xffeeb462),
      //titleTextStyle: TextStyle(fontFamily: "Handlee"),
      iconTheme: IconThemeData(
        color: const Color(0xff2c1d33),
      ),

      textTheme: TextTheme(
          headline6: TextStyle(color: const Color(0xff2c1d33), fontSize: 25)
      ),
    ),

    /* Calendar Styling */


    inputDecorationTheme: InputDecorationTheme(
      //Style of input fields
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
      //Style of input fields in focus
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: const Color(0xff2c1d33), width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
    ),
      primaryColorLight: const Color(0xff2c1d33),
    accentColor: const Color(0xff2c1d33),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(primary: const Color(0xff2c1d33),textStyle: TextStyle(color: Colors.white,fontFamily: "Handlee",inherit: false),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),

        ),
      ),
    ),

      primaryIconTheme: IconThemeData(
        color: const Color(0xff2c1d33),
      ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xffeeb462),
      selectedIconTheme: IconThemeData(color: Colors.white),
      selectedItemColor:  Colors.white,
      unselectedIconTheme: IconThemeData(color: const Color(0xff2c1d33)),
      unselectedItemColor: const Color(0xff2c1d33),
    )
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: "Handlee",
    brightness: Brightness.dark,
    backgroundColor: const Color(0xff302933),

    appBarTheme: AppBarTheme(
      color: const Color(0xff2c1d33),
      //titleTextStyle: TextStyle(fontFamily: "Handlee"),
      iconTheme: IconThemeData(
        color: const Color(0xffeeb462),
      ),
    centerTitle: true,
    textTheme: TextTheme(
        headline6: TextStyle(color: const Color(0xffeeb462),fontSize: 25)
    )
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
     style: ElevatedButton.styleFrom(onPrimary: Color(0xff2c1d33), primary: const Color(0xffeeb462), textStyle: TextStyle(color: const Color(0xff2c1d33),inherit: false,fontFamily: "Handlee"),
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(30.0),
     ),
    ),
    ),

      ///TODO: Color for inputfields when active
      inputDecorationTheme: InputDecorationTheme(
        //Style of input fields
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
          //Style of input fields in focus
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: const Color(0xff2c1d33), width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
      ),

    accentColor: Color(0xffeeb462),
    primaryColorDark: Color(0xffeeb462),

    primaryIconTheme: IconThemeData(
      color: Color(0xffeeb462),
    ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xff2c1d33),
        selectedIconTheme: IconThemeData(color: Colors.white),
        selectedItemColor: Colors.white,
        unselectedIconTheme: IconThemeData(color: const Color(0xffeeb462)),
        unselectedItemColor: const Color(0xffeeb462)
      )
  );
}