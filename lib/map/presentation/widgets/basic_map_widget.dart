import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../image_load.dart';

// Widget to present ground maps and floor maps in browsing mode
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
    assignImage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImages(context);
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
                  color: Theme.of(context).accentColor,
                )
              )
            ),
          ]
        ),
      ),
    );
  }
}

