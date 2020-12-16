//TODO: Change accordingly to UI design
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../locationAnimation.dart';
import 'widgets.dart';

class BasicMapWidget extends StatelessWidget {
  final String basicMapToShow;
  const BasicMapWidget ({Key key,this.basicMapToShow }):super(key: key);

  @override
  Widget build(BuildContext context){
    return  Container(
      child: ClipRect(
        child: Stack(
          children: [
             InteractiveViewer(
              minScale: 0.1,
              maxScale: 3.0,
                child:
                Image.asset(switchImage(basicMapToShow)),
             ),
            if (basicMapToShow!='basic' && basicMapToShow !='U' && basicMapToShow != 'R')
              Positioned (
                  top:10,
                  left:10,
                  child:Text( basicMapToShow,
                      style: TextStyle (
                        fontSize: 50,
                        backgroundColor: Colors.white,
                      )
                  )
              ),
              ]
          ),
        ),
      );
  }
}

String switchImage(String basicMapToShow) {
String image;
  switch (basicMapToShow) {
    case 'basic':
      return 'assets/basic.jpg';
  
    case 'U':
      return 'assets/U.jpg';

    case 'U1':
      return 'assets/U1.jpg';

    case 'U2':
      return 'assets/U2.jpg';

    case 'U3':
      return 'assets/U3.jpg';

    case 'R':
      return 'assets/R.jpg';

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