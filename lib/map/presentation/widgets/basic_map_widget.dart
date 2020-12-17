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
            if (basicMapToShow!='basic' && basicMapToShow !='U' && basicMapToShow != 'R' && basicMapToShow != 'T' )
              Positioned (
                  top:10,
                  left:10,
                  child:Text( basicMapToShow,
                      style: TextStyle (
                        fontSize: 50,
                        backgroundColor: Colors.white,
                        color: Colors.deepPurple[100],
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
      return 'assets/basic.png';
  
    case 'U':
      return 'assets/u1test.png';

    case 'U1':
      return 'assets/U1.png';

    case 'U2':
      return 'assets/U2.png';

    case 'U3':
      return 'assets/U3.png';

    case 'T':
      return 'assets/U.png';

    case 'T1':
      return 'assets/U1.png';

    case 'T2':
      return 'assets/U2.png';

    case 'T3':
      return 'assets/U3.png';

    case 'R':
      return 'assets/R.png';

    case 'R1':
      return 'assets/R1.png';

    case 'R2':
      return 'assets/R2.png';

    case 'R3':
      return 'assets/R3.png';

    default:
      return 'Can not find corresponding image';
  }
  
}