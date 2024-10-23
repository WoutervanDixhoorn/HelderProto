import 'package:flutter/material.dart';

class CornerBorderPainter extends CustomPainter {
  final double extraLineLength; // Length of the straight parts after the curve

  CornerBorderPainter({this.extraLineLength = 20}); // Default extra line length

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Top-left corner
    path.moveTo(0, 20); // Start from the vertical part before the curve
    path.quadraticBezierTo(0, 0, 20, 0); // Curve
    path.lineTo(20 + extraLineLength, 0); // Extend straight line to the right (x direction)
    path.moveTo(0, 20); // Start after the curve again
    path.lineTo(0, 20 + extraLineLength*2); // Extend straight line downwards (y direction)

    // Top-right corner
    path.moveTo(size.width - 20, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 20); // Curve
    path.lineTo(size.width, 20 + extraLineLength*2); // Extend straight downwards (y direction)
    path.moveTo(size.width - 20, 0); // Start after the curve again
    path.lineTo(size.width - 20 - extraLineLength, 0); // Extend straight left (x direction)

    // Bottom-right corner
    path.moveTo(size.width, size.height - 20);
    path.quadraticBezierTo(size.width, size.height, size.width - 20, size.height); // Curve
    path.lineTo(size.width - 20 - extraLineLength, size.height); // Extend straight to the left (x direction)
    path.moveTo(size.width, size.height - 20); // Start after the curve again
    path.lineTo(size.width, size.height - 20 - extraLineLength*2); // Extend straight upwards (y direction)

    // Bottom-left corner
    path.moveTo(20, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - 20); // Curve
    path.lineTo(0, size.height - 20 - extraLineLength*2); // Extend straight upwards (y direction)
    path.moveTo(20, size.height); // Start after the curve again
    path.lineTo(20 + extraLineLength, size.height); // Extend straight to the right (x direction)


    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class RoundedCornerBorderContainer extends StatelessWidget {
  const RoundedCornerBorderContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(550, 330), // Size of your container
      painter: CornerBorderPainter(extraLineLength: 40), // Adjust this value for longer lines after the curve
      child: const SizedBox(
        height: 550,
        width: 330,
      ),
    );
  }
}