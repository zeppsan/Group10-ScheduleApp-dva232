import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_dva232/schedule/thisweek.dart';

import '../../image_load.dart';

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
    assignImage();

    print('done loading images');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('precache images');
    precacheImages(context);
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

