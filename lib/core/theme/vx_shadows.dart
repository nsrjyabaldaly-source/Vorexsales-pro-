import 'package:flutter/material.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';

abstract final class VxShadows {
  /// Soft brand wash under primary CTAs — web `shadow-glow`:
  /// `0 0 80px -20px rgba(34, 227, 210, 0.45)`.
  static const glow = [
    BoxShadow(
      color: Color(0x7322E3D2),
      blurRadius: 80,
      spreadRadius: -20,
    ),
  ];

  static const panel = [
    BoxShadow(
      color: Color(0xB3000000),
      blurRadius: 80,
      spreadRadius: -32,
      offset: Offset(0, 24),
    ),
  ];

  /// Web mark: `drop-shadow(0 0 18px rgba(34,227,210,0.45))`.
  static List<BoxShadow> markGlow({bool enabled = true}) => enabled
      ? const [
          BoxShadow(
            color: Color(0x7322E3D2),
            blurRadius: 18,
            spreadRadius: 0,
          ),
        ]
      : const [];

  static const focus = [
    BoxShadow(color: VxColors.cyan, blurRadius: 0, spreadRadius: 2),
  ];
}
