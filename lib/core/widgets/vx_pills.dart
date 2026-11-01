import 'package:flutter/material.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';

class VxPill extends StatelessWidget {
  const VxPill({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.cyan = false,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final bool cyan;

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? Colors.white
        : cyan
            ? VxColors.cyan.withValues(alpha: 0.15)
            : Colors.transparent;
    final fg = selected
        ? VxColors.ink950
        : cyan
            ? VxColors.cyan
            : VxColors.mist300;
    return Material(
      color: bg,
      shape: StadiumBorder(
        side: selected ? BorderSide.none : const BorderSide(color: VxColors.hairline),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(label, style: TextStyle(fontSize: 14, color: fg)),
        ),
      ),
    );
  }
}

class VxStatusDot extends StatelessWidget {
  const VxStatusDot({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: VxColors.cyan.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(VxRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: VxColors.cyan,
              shape: BoxShape.circle,
            ),
          ),
          if (label != null) ...[
            const SizedBox(width: 6),
            Text(
              label!,
              style: const TextStyle(fontSize: 12, color: VxColors.cyan),
            ),
          ],
        ],
      ),
    );
  }
}
