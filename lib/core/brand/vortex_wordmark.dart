import 'package:flutter/material.dart';
import 'package:vortexsales/core/brand/brand.dart';
import 'package:vortexsales/core/brand/vortex_mark.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_typography.dart';

/// Wordmark matching web: white «Vortex» + cyan «Sales», Outfit Semibold 15.
class VortexWordmark extends StatelessWidget {
  const VortexWordmark({
    super.key,
    this.compact = false,
    this.markSize = 32,
    this.showMark = true,
  });

  final bool compact;
  final double markSize;
  final bool showMark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showMark)
          VortexMark(
            size: markSize,
            glow: true,
            radius: 12 * (markSize / 32),
          ),
        if (showMark && !compact) const SizedBox(width: 10),
        if (!compact)
          Text.rich(
            TextSpan(
              text: Brand.vortex,
              children: [
                TextSpan(
                  text: Brand.sales,
                  style: const TextStyle(color: VxColors.cyan),
                ),
              ],
            ),
            style: const TextStyle(
              fontFamily: VxTypography.display,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
              height: 1.1,
              color: Colors.white,
            ),
          ),
      ],
    );
  }
}
