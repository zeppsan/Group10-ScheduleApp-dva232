import 'package:flutter/cupertino.dart';
import 'package:schedule_dva232/map/data_domain/models/coordinates.dart';

class DirectionPainter extends CustomPainter {

  DirectionPainter({ @required this.direction});

  List<Coordinates> direction = List<Coordinates>();

  @override
  void paint(Canvas canvas, Size size) {

    int i = 0;
    double pointX = direction[i].x;
    double pointY = direction[i].y;

    Paint paint = Paint()
      ..color = Color(0xFF83fb91)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    Path path = Path();

    path.moveTo(pointX, pointY);

   for(i = 1; i < direction.length; i++){

     pointX = direction[i].x;
     pointY = direction[i].y;
      path.lineTo(pointX, pointY);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}