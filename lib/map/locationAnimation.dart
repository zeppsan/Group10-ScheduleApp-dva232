import 'package:flutter/cupertino.dart';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:schedule_dva232/map/DirectionPainter.dart';


class LocationAnimation extends StatefulWidget {
  @override
  _LocationAnimation createState() => _LocationAnimation();
}

class _LocationAnimation extends State<LocationAnimation> with TickerProviderStateMixin {

  AnimationController controller; // Manage the animation

  @override
    void initState() {
      super.initState();
      controller = AnimationController(duration: Duration(milliseconds: 2000), vsync: this) // Manage the animation
      ..forward();
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final double x = 820.0;
    final double y = -900.0;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(color: Colors.white),

      child: FittedBox(
        fit: BoxFit.contain,

        child: Stack(
            children: [
              Image.asset(
                'assets/R2.jpg',),

              PositionedTransition(
                rect: RelativeRectTween(
                  begin: RelativeRect.fromLTRB(x, y, 0, 0),
                  end: RelativeRect.fromLTRB(x, y + 300, 0, 0),
                ).animate(CurvedAnimation( parent: controller, curve: Curves.bounceIn.flipped)),

                child: Image.asset(
                  'assets/test.png',
                ),
              ),

              CustomPaint(
                painter: DirectionPainter(),
              ),
            ]
        ),
      ),
    );
  }
}