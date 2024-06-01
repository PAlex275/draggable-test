import 'dart:math';

import 'package:flutter/material.dart';

class CircleData {
  final Offset center;
  final double radius;
  final String data;

  CircleData({
    required this.center,
    required this.radius,
    required this.data,
  });
}

class FlowerWidget extends StatelessWidget {
  final double size;
  final Color centerColor;
  final Color petalColor;
  final int petalCount;

  const FlowerWidget({
    Key? key,
    required this.size,
    required this.centerColor,
    required this.petalColor,
    required this.petalCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: FlowerPainter(
        centerColor: centerColor,
        petalColor: petalColor,
        petalCount: petalCount,
        widgetSize: size,
      ),
    );
  }
}

class FlowerPainter extends CustomPainter {
  final Color centerColor;
  final Color petalColor;
  final int petalCount;
  final double widgetSize;

  FlowerPainter({
    required this.centerColor,
    required this.petalColor,
    required this.petalCount,
    required this.widgetSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double petalRadius = size.width / 2; // Adjust petal distance

    // Draw petals
    final petalPaint = Paint()..color = petalColor;
    for (int i = 0; i < petalCount; i++) {
      final petalAngle = i * (2 * pi / petalCount);
      final petalCenter = Offset(
        center.dx + petalRadius * cos(petalAngle),
        center.dy + petalRadius * sin(petalAngle),
      );
      final petalRadiusCurrent = widgetSize / 5; // Adjust petal size
      canvas.drawCircle(petalCenter, petalRadiusCurrent, petalPaint);

      // Add data on each petal
      const textStyle = TextStyle(color: Colors.black);
      final textPainter = TextPainter(
        text: TextSpan(text: 'Petal $i', style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          petalCenter.dx - textPainter.width / 2,
          petalCenter.dy - textPainter.height / 2,
        ),
      );
    }

    // Draw center circle
    final centerPaint = Paint()..color = centerColor;
    final centerRadius = widgetSize / 2.5; // Adjust center size
    canvas.drawCircle(center, centerRadius, centerPaint);

    // Add data on center circle
    const textStyle = TextStyle(color: Colors.black);
    final textPainter = TextPainter(
      text: const TextSpan(text: 'Center', style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
