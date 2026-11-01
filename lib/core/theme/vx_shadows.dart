import 'package:flutter/material.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';

abstract final class VxShadows {
  static const glow = [
    BoxShadow(
      color: Color(0x7322E3D2),
      blurRadius: 80,
      spreadRadius: -20,
      offset: Offset(0, 0),
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
