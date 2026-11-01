import 'package:flutter/material.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/widgets/vx_aurora.dart';

class VxScaffold extends StatelessWidget {
  const VxScaffold({
    super.key,
    required this.body,
    this.bottom,
    this.padding,
    this.safe = true,
  });

  final Widget body;
  final Widget? bottom;
  final EdgeInsetsGeometry? padding;
  final bool safe;

  @override
  Widget build(BuildContext context) {
    Widget content = body;
    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }
    if (safe) {
      content = SafeArea(bottom: bottom == null, child: content);
    }
    return Scaffold(
      backgroundColor: VxColors.ink900,
      body: VxAurora(
        child: Column(
          children: [
            Expanded(child: content),
            ?bottom,
          ],
        ),
      ),
    );
  }
}
