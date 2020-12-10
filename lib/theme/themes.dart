/*
This will work as an CSS file, if you want to change color of buttons
 */
import 'package:flutter/material.dart';

class AppTheme{
  AppTheme._();
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    //scaffoldBackgroundColor: Colors.orange[50],
    /*scaffoldBackgroundColor: Container(decoration: BoxDecoration( //VARFÖR KAN JAG INTE FÅ EN LINEAR GRADIENT BACKGROUND VARFÖR MÅSTE DET GÖRAS I CONTAINER????
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.deepPurple,
          Colors.orange
        ]
      )
    ),),*/

    appBarTheme: AppBarTheme(
      color: Colors.deepPurple[700],
      iconTheme: IconThemeData(
        color: Colors.orangeAccent,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(primary: Colors.orangeAccent),
    ),

      primaryIconTheme: IconThemeData(
        color: Colors.orangeAccent,
      ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.deepPurple[700],
      selectedIconTheme: IconThemeData(color: Colors.white),
      selectedItemColor:  Colors.white,
      unselectedIconTheme: IconThemeData(color: Colors.white60),
      unselectedItemColor: Colors.white60,
    )
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    /*backgroundColor: Colors.black12, //DETTA BEHÖVS FÖRMODLIGEN INTE OM INTE NÅGON VILL SITTA OCH FINSLIPA DEN KODEN
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
    ),*/
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black38,
        selectedIconTheme: IconThemeData(color: Colors.orangeAccent),
        selectedLabelStyle: TextStyle(color:Colors.orangeAccent), //ÄR FÖRMODLIGEN FEL EFTERSOM DEN INTE TAR DENNA ANDRA FÄRG
        unselectedIconTheme: IconThemeData(color: Colors.orange),
        unselectedLabelStyle: TextStyle(color: Colors.orange) //ÄR FÖRMODLIGEN FEL EFTERSOM DEN INTE TAR DENNA ANDRA FÄRG
      )
  );
}