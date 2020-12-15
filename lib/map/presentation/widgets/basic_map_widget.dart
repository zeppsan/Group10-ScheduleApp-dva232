//TODO: Change accordingly to UI design
import 'package:flutter/cupertino.dart';
import '../../locationAnimation.dart';
import 'widgets.dart';

class BasicMapWidget extends StatelessWidget {
  final String basicMapToShow;
  const BasicMapWidget ({Key key,this.basicMapToShow }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0,10.0,0.0),
      child: Container(
        child: ClipRect(
          child: InteractiveViewer(
            minScale: 0.1,
            maxScale: 3.0,
            child: Image.asset(switchImage(basicMapToShow)),
          ),
        ),
      ),
    );
  }
}

String switchImage(String basicMapToShow) {

  switch (basicMapToShow) {
    case 'basic':
      return 'assets/U1.jpg';
  
    case 'U':
      return 'assets/U2.jpg';

    case 'R':
      return 'assets/R1.jpg';

    default:
      return 'Can not find corresponding image';
  }
  
}