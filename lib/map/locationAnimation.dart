import 'package:flutter/cupertino.dart';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:schedule_dva232/map/DirectionPainter.dart';

import 'data_domain/models/room.dart';


class LocationAnimation extends StatefulWidget {
  final Room room;
  bool showPosition;
  bool showPath;

  LocationAnimation ({this.room, this.showPosition, this.showPath});

  @override
  _LocationAnimation createState() => _LocationAnimation();
}

class _LocationAnimation extends State<LocationAnimation> with TickerProviderStateMixin {
  String floorImage;
  double x;
  double y;
  AnimationController controller; // Manage the animation

  @override
    void initState() {
      super.initState();
      floorImage = widget.room.building.name + widget.room.floor.toString();
      x = widget.room.position.x;
      y = widget.room.position.y;
      print(x);
      print(y);
      print(floorImage);
      controller = AnimationController(duration: Duration(milliseconds: 2000), vsync: this) // Manage the animation
      ..forward();
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {

    return Container(
      child:ClipRect(
      child: InteractiveViewer(
        minScale: 0.1,
        maxScale: 3.0,
        //child:
          //width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,// * 0.55,
          //decoration: BoxDecoration(color: Colors.white),

          //child: FittedBox(
            //fit: BoxFit.contain,

            child: Stack(
                children: [
                  Image.asset(
                    getFloorImage(floorImage)),
                  if(widget.showPosition)
                  PositionedTransition(
                    rect: RelativeRectTween(
                      begin: RelativeRect.fromLTRB(x, y, 0, 0),
                      end: RelativeRect.fromLTRB(x, y + 300, 0, 0),
                    ).animate(CurvedAnimation( parent: controller, curve: Curves.bounceIn.flipped)),

                    child: Image.asset(
                      'assets/test.png',
                    ),
                  ),
                  if(widget.showPath)
                  CustomPaint(
                    painter: DirectionPainter(),
                  ),
                ]
            ),
          //),
        ),
      ),
    );
  }
}
String getFloorImage(String building){
  print('gets floor image');
  switch (building) {

    case 'U1':
      return 'assets/U1.jpg';

    case 'U2':
      return 'assets/U2.jpg';

    case 'U3':
      return 'assets/U3.jpg';

    case 'R1':
      return 'assets/R1.jpg';

    case 'R2':
      return 'assets/R2.jpg';

    case 'R3':
      return 'assets/R3.jpg';

    default:
      return 'Can not find corresponding image';
  }
}