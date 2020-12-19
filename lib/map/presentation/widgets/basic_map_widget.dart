import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_dva232/schedule/thisweek.dart';

class BasicMapWidget extends StatefulWidget {
  final String basicMapToShow;

  const BasicMapWidget({Key key, this.basicMapToShow }) :super(key: key);

  @override
  _BasicMapWidget createState() => _BasicMapWidget();
}

class _BasicMapWidget extends State<BasicMapWidget> {

  Image basic, u_building, r_building, u1, u2, u3, r1, r2, r3;

  @override
  void initState() {
    super.initState();
    print('loading images');
    basic = Image.asset('assets/basic.png');
    u_building = Image.asset('assets/U.png');
    r_building = Image.asset('assets/R.png');
    u1 = Image.asset('assets/U1.png');
    u2 = Image.asset('assets/U2.png');
    u3 = Image.asset('assets/U3.png');
    r1 = Image.asset('assets/R1.png');
    r2 = Image.asset('assets/R2.png');
    r3 = Image.asset('assets/R3.png');
    print('done loading images');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('precache images');
    precacheImage(basic.image, context);
    precacheImage(u_building.image, context);
    precacheImage(r_building.image, context);
    precacheImage(u1.image, context);
    precacheImage(u2.image, context);
    precacheImage(u3.image, context);
    precacheImage(r1.image, context);
    precacheImage(r2.image, context);
    precacheImage(r3.image, context);
    print('precache images done');
  }

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
                  Image.asset(switchImage(widget.basicMapToShow)),
               ),
              if (widget.basicMapToShow!='basic' && widget.basicMapToShow !='U' && widget.basicMapToShow != 'R' && widget.basicMapToShow != 'T' )
                Positioned (
                    top:10,
                    left:10,
                    child:Text( widget.basicMapToShow,
                        style: TextStyle (
                          fontSize: 50,
                          color: lightTheme ? const Color(0xff2c1d33) : const Color(0xffeeb462),
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
      return 'assets/U.png';

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