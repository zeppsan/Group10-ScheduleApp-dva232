
import 'dart:ui';

import 'package:flutter/cupertino.dart';

Image basic, u_building, r_building, u1, u2, u3, r1, r2, r3;

void assignImage() {
  basic = Image.asset('assets/basic.png');
  u_building = Image.asset('assets/U.png');
  r_building = Image.asset('assets/R.png');
  u1 = Image.asset('assets/U1.png');
  u2 = Image.asset('assets/U2.png');
  u3 = Image.asset('assets/U3.png');
  r1 = Image.asset('assets/R1.png');
  r2 = Image.asset('assets/R2.png');
  r3 = Image.asset('assets/R3.png');
}

void precacheImages (context) {
  precacheImage(basic.image, context);
  precacheImage(u_building.image, context);
  precacheImage(r_building.image, context);
  precacheImage(u1.image, context);
  precacheImage(u2.image, context);
  precacheImage(u3.image, context);
  precacheImage(r1.image, context);
  precacheImage(r2.image, context);
  precacheImage(r3.image, context);
}

String switchImage(String basicMapToShow) {

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