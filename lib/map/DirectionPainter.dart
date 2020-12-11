import 'package:flutter/cupertino.dart';

class DirectionPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {

    double pointX = 142;
    double pointY = 245;

    String room = "alfa";

    Paint paint = Paint()
      ..color = Color(0xFF83fb91)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Path path = Path();

    if(room == "alfa")
    {
      path.moveTo(pointX, pointY);
      path.lineTo(142, 230);
      path.lineTo(160, 230);
      path.lineTo(160, 220);
    }
    else if(room == "beta")
    {
      path.moveTo(pointX, pointY);
      path.lineTo(142, 230);
      path.lineTo(177, 230);
      path.lineTo(177, 165);
      path.lineTo(165, 165);
    }

    canvas.drawPath(path, paint);
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}