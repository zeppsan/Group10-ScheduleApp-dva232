
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopMenu extends StatelessWidget{
  //final String title;

  //TopNavigation({this.title})

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.more_vert_outlined),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          );
        }
    );
  }
}