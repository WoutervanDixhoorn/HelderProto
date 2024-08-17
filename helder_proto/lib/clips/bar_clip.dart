import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TAppBarClipLeft extends CustomClipper<Path>{

  @override
  Path getClip(Size size) {
    var path = Path();

    final startCurve = Offset(0, size.height);
    final endCurve = Offset(30, size.height);
    path.quadraticBezierTo(startCurve.dx, startCurve.dy, endCurve.dx, endCurve.dy);
    
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class TAppBarClipRight extends CustomClipper<Path>{

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width-30, 0);
    
    final startCurve = Offset(size.width-30, size.height);
    final endCurve = Offset(size.width, 0);
    path.quadraticBezierTo(startCurve.dx, startCurve.dy, endCurve.dx, endCurve.dy);
    

    path.lineTo(size.width, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}