import 'package:flutter/material.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';

class VxAurora extends StatelessWidget {
  const VxAurora({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: ColoredBox(color: VxColors.ink900)),
        const Positioned(
          left: -80,
          top: -120,
          child: IgnorePointer(
            child: _Blob(color: VxColors.auroraCyan, size: 420),
          ),
        ),
        const Positioned(
          right: -60,
          top: -40,
          child: IgnorePointer(
            child: _Blob(color: VxColors.auroraViolet, size: 340),
          ),
        ),
        const Positioned.fill(child: IgnorePointer(child: _GridFade())),
        child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}

class _GridFade extends StatelessWidget {
  const _GridFade();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GridPainter());
  }
}

class _GridPainter extends CustomPainter {
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
