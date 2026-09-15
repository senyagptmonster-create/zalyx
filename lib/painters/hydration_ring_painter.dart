import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/zalyx_theme.dart';

class HydrationRingPainter extends CustomPainter {
  final double progress;
  final double wavePhase;

  HydrationRingPainter({required this.progress, required this.wavePhase});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.42;

    // Track circle
    final trackPaint = Paint()
      ..color = ZalyxTheme.edge.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    canvas.drawCircle(center, radius, trackPaint);

    // Inner wave clip
    final innerRadius = radius - 10;
    canvas.save();
    final clipPath = Path()..addOval(Rect.fromCircle(center: center, radius: innerRadius));
    canvas.clipPath(clipPath);

    // Wave liquid filling from bottom to top based on progress
    final waterLevel = center.dy + innerRadius - (2 * innerRadius * progress.clamp(0.0, 1.0));
    final wavePath = Path();
    wavePath.moveTo(center.dx - innerRadius, size.height);
    wavePath.lineTo(center.dx - innerRadius, waterLevel);

    for (double x = center.dx - innerRadius; x <= center.dx + innerRadius; x += 4) {
      final y = waterLevel + sin((x / 20) + wavePhase) * 4;
      wavePath.lineTo(x, y);
    }

    wavePath.lineTo(center.dx + innerRadius, size.height);
    wavePath.close();

    final wavePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          ZalyxTheme.accentLight.withValues(alpha: 0.4),
          ZalyxTheme.accent.withValues(alpha: 0.7),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: center, radius: innerRadius));

    canvas.drawPath(wavePath, wavePaint);
    canvas.restore();

    // Progress Arc on outer rim
    final sweepAngle = 2 * pi * progress.clamp(0.0, 1.0);
    final arcPaint = Paint()
      ..shader = SweepGradient(
        colors: const [
          ZalyxTheme.accentLight,
          ZalyxTheme.accent,
        ],
        transform: const GradientRotation(-pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 14;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      arcPaint,
    );

    // Droplet icon or dot at head of arc
    if (progress > 0) {
      final headAngle = -pi / 2 + sweepAngle;
      final headPoint = Offset(
        center.dx + radius * cos(headAngle),
        center.dy + radius * sin(headAngle),
      );
      final dotPaint = Paint()..color = Colors.white;
      final dotStroke = Paint()
        ..color = ZalyxTheme.accent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawCircle(headPoint, 7, dotPaint);
      canvas.drawCircle(headPoint, 7, dotStroke);
    }
  }

  @override
  bool shouldRepaint(covariant HydrationRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.wavePhase != wavePhase;
  }
}
