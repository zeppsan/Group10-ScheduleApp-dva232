import 'package:flutter/cupertino.dart';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';


class LocationAnimation extends StatefulWidget {
  @override
  _LocationAnimation createState() => _LocationAnimation();
}

class _LocationAnimation extends State<LocationAnimation> with TickerProviderStateMixin {

  AnimationController controller; // Manage the animation
  //Animation animation; //"guides" the animation

  @override
    void initState() {
      super.initState();
      controller = AnimationController(duration: Duration(milliseconds: 2500), vsync: this) // Manage the animation
    //animation = CurvedAnimation(curve: Curves.bounceIn.flipped); //"guides" the animation
   // animation = CurvedAnimation(parent: controller, curve: Curves.bounceIn)
   // animation = Tween<double>(begin: 0, end: 100).animate(controller)
      ..forward();
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final double x = 980;
    final double y = 1080;
   //return LayoutBuilder(
      final Size biggest = Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.55);
        return Container(
          width: MediaQuery.of(context).size.width,

          // height: 340,
          height: MediaQuery.of(context).size.height * 0.55,
          decoration: BoxDecoration(color: Colors.white),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Stack(
                children: [
                  Image.asset(
                  'assets/U1.2.jpg',),

                  PositionedTransition(
                    rect: RelativeRectTween(
                        begin: RelativeRect.fromSize(Rect.fromLTRB(0, 0, 100, 100), biggest),
                        end: RelativeRect.fromSize(Rect.fromLTRB(0, 300, 100, 100), biggest),
                    ).animate(CurvedAnimation( parent: controller, curve: Curves.bounceIn.flipped)),

                    child: Image.asset(
                      'assets/test.png',
                    ),
                  ),
                ]
            ),
          ),
        );
    //  },
    //);
  }
}