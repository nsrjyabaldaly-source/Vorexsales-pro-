import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';

/// Frosted panel — mirrors web `.glass` (blur + ink wash + hairline).
class VxGlass extends StatelessWidget {
  const VxGlass({
    super.key,
    required this.child,
    this.padding,
    this.radius = VxRadii.card,
    this.width,
    this.height,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: VxColors.glassBorder),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [VxColors.glassTop, VxColors.glassBottom],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class VxHairline extends StatelessWidget {
  const VxHairline({
    super.key,
    required this.child,
    this.radius = VxRadii.input,
    this.padding,
    this.color,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: VxColors.hairline),
      ),
      child: padding == null ? child : Padding(padding: padding!, child: child),
    );
  }
}
