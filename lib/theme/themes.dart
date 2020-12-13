/*
This will work as an CSS file, if you want to change color of buttons
 */
import 'package:flutter/material.dart';

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
      color: const Color(0xffeacea5),
      iconTheme: IconThemeData(
        color: const Color(0xffdfb15b),
      ),
      textTheme: TextTheme(
          headline6: TextStyle(color: const Color(0xff2c1d33),)
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(primary: const Color(0xff2c1d33)),
    ),

      primaryIconTheme: IconThemeData(
        color: const Color(0xffdfb15b),
      ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xffeacea5),
      selectedIconTheme: IconThemeData(color: Colors.white),
      selectedItemColor:  Colors.white,
      unselectedIconTheme: IconThemeData(color: const Color(0xff2c1d33)),
      unselectedItemColor: const Color(0xff2c1d33),
    )
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: const Color(0xff302933), //DETTA BEHÖVS FÖRMODLIGEN INTE OM INTE NÅGON VILL SITTA OCH FINSLIPA DEN KODEN
    appBarTheme: AppBarTheme(
      color: const Color(0xff2c1d33),
      iconTheme: IconThemeData(
        color: const Color(0xffeeb462),
      ),
    textTheme: TextTheme(
        headline6: TextStyle(color: const Color(0xffeeb462),)
    )
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
     style: ElevatedButton.styleFrom(primary: const Color(0xffeeb462))
    ),

    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    /*textTheme: TextTheme(
      headline6: TextStyle(color: Colors.blue,),
      subtitle2: TextStyle(color: Colors.blueAccent),
    ),*/

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xff2c1d33),
        selectedIconTheme: IconThemeData(color: const Color(0xff95d1a3)),
        selectedItemColor: const Color(0xff95d1a3),
        unselectedIconTheme: IconThemeData(color: const Color(0xffeeb462)),
        unselectedItemColor: const Color(0xffeeb462)
      )
  );
}