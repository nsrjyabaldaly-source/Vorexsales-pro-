import 'package:flutter/material.dart';
import 'package:vortexsales/core/brand/brand_assets.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/core/theme/vx_shadows.dart';

/// Official VortexSales mark — the same asset as AMREKA2 `public/icon.jpg`.
class VortexMark extends StatelessWidget {
  const VortexMark({
    super.key,
    this.size = 32,
    this.glow = false,
    this.radius,
  });

  final double size;
  final bool glow;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final r = radius ?? VxRadii.mark * (size / 64);
    final child = ClipRRect(
      borderRadius: BorderRadius.circular(r),
      child: Image.asset(
        BrandAssets.customLogo,
        width: size,
        height: size,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
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
