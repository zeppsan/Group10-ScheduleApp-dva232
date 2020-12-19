/*
This will work as an CSS file, if you want to change color of buttons
 */
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class AppTheme{
  AppTheme._();
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    /*scaffoldBackgroundColor: Container(decoration: BoxDecoration( //VARFÖR KAN JAG INTE FÅ EN LINEAR GRADIENT BACKGROUND VARFÖR MÅSTE DET GÖRAS I CONTAINER????
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xff452c52),
          Colors.black
        ]
      )
    ),),*/

    appBarTheme: AppBarTheme(
      color: const Color(0xffeeb462),
      iconTheme: IconThemeData(
        color: const Color(0xff2c1d33),
      ),
      centerTitle: true,
      textTheme: TextTheme(
          headline6: TextStyle(color: const Color(0xff2c1d33), fontSize: 20)
      ),
    ),

    /* Calendar Styling */

      ///TODO: Color for inputfields when active
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      )
    ),
      primaryColorLight: const Color(0xff2c1d33),

    accentColor: const Color(0xff2c1d33),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(primary: const Color(0xff2c1d33),textStyle: TextStyle(color: Colors.white),
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
    brightness: Brightness.dark,
    backgroundColor: const Color(0xff302933),
    appBarTheme: AppBarTheme(
      color: const Color(0xff2c1d33),
      iconTheme: IconThemeData(
        color: const Color(0xffeeb462),
      ),
    centerTitle: true,
    textTheme: TextTheme(
        headline6: TextStyle(color: const Color(0xffeeb462),fontSize: 20,)
    )
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
     style: ElevatedButton.styleFrom(onPrimary: Color(0xff2c1d33), primary: const Color(0xffeeb462), textStyle: TextStyle(color: const Color(0xff2c1d33)),
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(30.0),
     ),
    ),
    ),

      ///TODO: Color for inputfields when active
      inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(25.0),
          )
      ),

    accentColor: Color(0xffeeb462),
    primaryColorDark: Color(0xffeeb462),
    primaryIconTheme: IconThemeData(
      color: Color(0xffeeb462),
    ),
    /*textTheme: TextTheme(
      headline6: TextStyle(color: Colors.blue,),
      subtitle2: TextStyle(color: Colors.blueAccent),
    ),*/

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xff2c1d33),
        selectedIconTheme: IconThemeData(color: Colors.white),
        selectedItemColor: Colors.white,
        unselectedIconTheme: IconThemeData(color: const Color(0xffeeb462)),
        unselectedItemColor: const Color(0xffeeb462)
      )
  );
}