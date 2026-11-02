import 'package:flutter/material.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';

/// Same atmosphere as the live website body:
/// cyan wash at 12%/-10%, violet wash at 92%/0%, faint 56px grid.
class VxAurora extends StatelessWidget {
  const VxAurora({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: ColoredBox(color: VxColors.ink900)),
        const Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.76, -1.2),
                  radius: 1.15,
                  colors: [VxColors.auroraCyan, Color(0x0022E3D2)],
                  stops: [0, 0.55],
                ),
              ),
            ),
          ),
        ),
        const Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.84, -1.0),
                  radius: 0.95,
                  colors: [VxColors.auroraViolet, Color(0x008B6CFF)],
                  stops: [0, 0.50],
                ),
              ),
            ),
          ),
        ),
        const Positioned.fill(child: IgnorePointer(child: _GridFade())),
        child,
      ],
    );
  }
}

class _GridFade extends StatelessWidget {
  const _GridFade();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(painter: _GridPainter(), child: SizedBox.expand());
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const step = 56.0;
    final paint = Paint()
      ..color = VxColors.gridLine
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
