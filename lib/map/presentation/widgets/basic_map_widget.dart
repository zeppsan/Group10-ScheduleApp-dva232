//TODO: Change accordingly to UI design
import 'package:flutter/cupertino.dart';
import 'widgets.dart';

class BasicMapWidget extends StatelessWidget {
  final String basicMapToShow;
  const BasicMapWidget ({Key key,this.basicMapToShow }):super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (basicMapToShow) {
      case 'basic':
        return Text('here is the basic map with NO building highlighted');
      case 'U':
        return Column(
            children: <Widget> [
              Text('here is the basic map with U building highlighted'),
            ]
        );
      case 'R':
        return Column(
            children: <Widget> [
              Text('here is the basic map with R building highlighted'),
            ]
          );
      case 'T':
        return Column(
            children: <Widget> [
              Text('here is the basic map with T building highlighted'),
            ]
          );
      default:
        return Text('Can not find corresponding image');
    }
  }
}