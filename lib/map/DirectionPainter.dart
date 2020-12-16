import 'package:flutter/cupertino.dart';
import 'package:schedule_dva232/map/data_domain/models/coordinates.dart';

class DirectionPainter extends CustomPainter {

  DirectionPainter({@required this.searchedRoom, @required this.direction});

  final String searchedRoom;
  List<Coordinates> direction = List<Coordinates>();

  @override
  void paint(Canvas canvas, Size size) {

   double pointX;
   double pointY;

    Paint paint = Paint()
      ..color = Color(0xFF83fb91)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    Path path = Path();
    int i = 0;

    pointX = direction[i].x;
    pointY = direction[i].y;

    print(pointX);
    print(pointY);

    path.moveTo(pointX, pointY);
    print(direction.length);

   for(i = 1; i < direction.length; i++){

     pointX = direction[i].x;
     pointY = direction[i].y;
      path.lineTo(pointX, pointY);
      print(pointX);
      print(pointY);

    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}