import 'dart:math';
import 'package:flutter/material.dart';

class RouletteWheel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roulette Wheel'),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          child: CustomPaint(
            painter: RoulettePainter(),
          ),
        ),
      ),
    );
  }
}

class RoulettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    // Define the golden wood color gradient
    final woodGradient = RadialGradient(
      colors: [Color(0xFFD4AF80), Color(0xFF8B4610)],
      stops: [0.1, 0.9],
    );

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20 // Thickness of the edge
      ..shader = woodGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, paint);

    // Draw wooden heart shape in the center
    Path path = Path();
    path.moveTo(center.dx, center.dy - radius * 0.25);
    path.cubicTo(
      center.dx + radius * 0.4, center.dy - radius * 0.55,
      center.dx + radius * 0.8, center.dy - radius * 0.18,
      center.dx, center.dy + radius * 0.5,
    );
    path.cubicTo(
      center.dx - radius * 0.8, center.dy - radius * 0.18,
      center.dx - radius * 0.4, center.dy - radius * 0.55,
      center.dx, center.dy - radius * 0.25,
    );
    paint.style = PaintingStyle.fill;
    paint.shader = woodGradient.createShader(
      Rect.fromCircle(center: center, radius: radius * 0.20),
    );
    canvas.drawPath(path, paint);

    // Draw holes inside the edges of the roulette wheel
    double holeRadius = 15; // Adjust the size of the holes
    double holeBackgroundWidth = 40; // Adjust the width of the hole background
    double holeBackgroundHeight = 40; // Adjust the height of the hole background

    Paint blackPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;

    Paint whitePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red;

    double innerRadius = radius * 0.72; // Adjust the inner radius of the holes

    for (int i = 0; i < 8; i++) {
      double angle = 2 * pi * i / 8;
      double x = center.dx + innerRadius * cos(angle);
      double y = center.dy + innerRadius * sin(angle);

      // Draw hole background
      Paint holeBackgroundPaint = i % 2 == 0 ? blackPaint : whitePaint;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, y),
            width: holeBackgroundWidth,
            height: holeBackgroundHeight,
          ),
          Radius.circular(holeBackgroundWidth / 2),
        ),
        holeBackgroundPaint,
      );

      // Draw hole
      Paint holePaint = i % 2 == 0 ? whitePaint : blackPaint;
      canvas.drawCircle(Offset(x, y), holeRadius, holePaint);

      // Draw line from hole to the heart
      // Paint linePaint = Paint()
      //   ..style = PaintingStyle.stroke
      //   ..color = i % 2 == 0 ? Colors.black : Colors.red
      //   ..strokeWidth = 10;
      //
      // canvas.drawLine(Offset(x, y), center, linePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}




