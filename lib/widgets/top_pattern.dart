import 'package:flutter/material.dart';
import '../main.dart';

class TopPattern extends StatelessWidget {
  const TopPattern({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: CustomPaint(painter: PatternPainter()),
    );
  }
}

class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = kPrimary
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final dotPaint = Paint()
      ..color = kPrimary
      ..style = PaintingStyle.fill;

    final pLeft = Offset(size.width * 0.19, size.height * 0.30);
    final pMid = Offset(size.width * 0.41, size.height * 0.82);
    final pRight = Offset(size.width * 0.61, size.height * 0.16);
    final pFar = Offset(size.width * 0.85, size.height * 0.44);
    final pDotOnly = Offset(size.width * 0.97, size.height * 0.56);

    canvas.drawLine(
      Offset(size.width * 0.00, size.height * 0.14),
      pLeft,
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.00, size.height * 0.38),
      pLeft,
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.06, size.height * 0.68),
      pLeft,
      linePaint,
    );

    final mainPath = Path()
      ..moveTo(pLeft.dx, pLeft.dy)
      ..lineTo(pMid.dx, pMid.dy)
      ..lineTo(pRight.dx, pRight.dy)
      ..lineTo(pFar.dx, pFar.dy);

    canvas.drawPath(mainPath, linePaint);

    canvas.drawLine(
      pMid,
      Offset(size.width * 0.79, size.height * 0.62),
      linePaint,
    );
    canvas.drawLine(
      pRight,
      Offset(size.width * 0.79, size.height * 0.62),
      linePaint,
    );
    canvas.drawLine(
      pRight,
      Offset(size.width * 0.97, size.height * 0.12),
      linePaint,
    );
    canvas.drawLine(
      pFar,
      Offset(size.width * 1.02, size.height * 0.20),
      linePaint,
    );
    canvas.drawLine(pFar, pDotOnly, linePaint);

    canvas.drawCircle(pLeft, 18, dotPaint);
    canvas.drawCircle(pMid, 13, dotPaint);
    canvas.drawCircle(pRight, 11, dotPaint);
    canvas.drawCircle(pFar, 11, dotPaint);
    canvas.drawCircle(pDotOnly, 10, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
