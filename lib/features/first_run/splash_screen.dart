import 'package:flutter/material.dart';
import 'package:vortexsales/core/brand/brand.dart';
import 'package:vortexsales/core/brand/vortex_mark.dart';
import 'package:vortexsales/core/brand/vortex_wordmark.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/widgets/vx_aurora.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: VxColors.ink900,
      body: VxAurora(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VortexMark(size: 96, glow: true),
              SizedBox(height: 20),
              VortexWordmark(showMark: false),
              SizedBox(height: 10),
              Text(
                Brand.company,
                style: TextStyle(fontSize: 12, color: VxColors.mist500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
