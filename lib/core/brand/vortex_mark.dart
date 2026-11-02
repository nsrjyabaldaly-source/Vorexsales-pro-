import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/core/theme/vx_shadows.dart';

/// Official VortexSales mark — vector paint matching web `logo.svg` 1:1.
class VortexMark extends StatelessWidget {
  const VortexMark({
    super.key,
    this.size = 32,
    this.glow = false,
    this.radius,
  });

  const VortexMark.lockup({super.key})
      : size = 32,
        glow = true,
        radius = 12;

  const VortexMark.chat({super.key, this.glow = false})
      : size = 32,
        radius = null;

  final double size;
  final bool glow;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final r = radius ?? VxRadii.mark * (size / 64);
    final child = ClipRRect(
      borderRadius: BorderRadius.circular(r),
      child: SizedBox(
        width: size,
        height: size,
        child: const CustomPaint(painter: _VortexMarkPainter()),
      ),
    );
    if (!glow) return child;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r),
        boxShadow: VxShadows.markGlow(),
      ),
      child: child,
    );
  }
}

class _VortexMarkPainter extends CustomPainter {
  const _VortexMarkPainter();

  static const _orbit = LinearGradient(
    begin: Alignment(-0.75, -0.875),
    end: Alignment(0.8125, 0.875),
    colors: [
      VxColors.cyan,
      VxColors.logoMid,
      VxColors.violet,
    ],
    stops: [0, 0.55, 1],
  );

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    canvas.scale(s / 64);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 64, 64),
        const Radius.circular(16),
      ),
      Paint()..color = VxColors.ink900,
    );

    _orbitArc(canvas, radius: 22, stroke: 3.4, dash: 92, gap: 46, rotationDeg: -28, shader: true);
    _orbitArc(canvas, radius: 15.5, stroke: 3.1, dash: 64, gap: 34, rotationDeg: 38, shader: true);
    _orbitArc(canvas, radius: 8.5, stroke: 3, dash: 28, gap: 26, rotationDeg: -48, shader: false);

    canvas.drawCircle(
      const Offset(32, 32),
      3.15,
      Paint()..color = VxColors.logoCore,
    );
  }

  void _orbitArc(
    Canvas canvas, {
    required double radius,
    required double stroke,
    required double dash,
    required double gap,
    required double rotationDeg,
    required bool shader,
  }) {
    final rect = Rect.fromCircle(center: const Offset(32, 32), radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    if (shader) {
      paint.shader = _orbit.createShader(const Rect.fromLTWH(0, 0, 64, 64));
    } else {
      paint.color = VxColors.cyan;
    }

    canvas.save();
    canvas.translate(32, 32);
    canvas.rotate(rotationDeg * math.pi / 180);
    canvas.translate(-32, -32);

    final circumference = 2 * math.pi * radius;
    final unit = dash + gap;
    var drawn = 0.0;
    while (drawn < circumference - 0.5) {
      final len = math.min(dash, circumference - drawn);
      final start = drawn / circumference * 2 * math.pi - math.pi / 2;
      final sweep = len / circumference * 2 * math.pi;
      canvas.drawArc(rect, start, sweep, false, paint);
      drawn += unit;
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
