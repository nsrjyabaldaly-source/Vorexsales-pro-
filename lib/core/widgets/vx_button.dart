import 'package:flutter/material.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/core/theme/vx_shadows.dart';

enum VxButtonVariant { primary, secondary, ghost, danger }
enum VxButtonSize { sm, md, lg, icon }

class VxButton extends StatelessWidget {
  const VxButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = VxButtonVariant.primary,
    this.size = VxButtonSize.md,
    this.expanded = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final VxButtonVariant variant;
  final VxButtonSize size;
  final bool expanded;
  final IconData? icon;

  double get _height => switch (size) {
        VxButtonSize.sm => 32,
        VxButtonSize.md => 40,
        VxButtonSize.lg => 48,
        VxButtonSize.icon => 40,
      };

  EdgeInsets get _padding => switch (size) {
        VxButtonSize.sm => const EdgeInsets.symmetric(horizontal: 12),
        VxButtonSize.md => const EdgeInsets.symmetric(horizontal: 16),
        VxButtonSize.lg => const EdgeInsets.symmetric(horizontal: 24),
        VxButtonSize.icon => EdgeInsets.zero,
      };

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final child = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: size == VxButtonSize.sm ? 14 : 16, color: _fg),
          if (label.isNotEmpty) const SizedBox(width: 8),
        ],
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(
              color: _fg,
              fontWeight: variant == VxButtonVariant.primary
                  ? FontWeight.w600
                  : FontWeight.w500,
              fontSize: size == VxButtonSize.sm
                  ? 12
                  : size == VxButtonSize.lg
                      ? 15
                      : 14,
            ),
          ),
      ],
    );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(VxRadii.pill),
      side: variant == VxButtonVariant.secondary || variant == VxButtonVariant.ghost
          ? const BorderSide(color: VxColors.hairline)
          : BorderSide.none,
    );

    Widget button;
    if (variant == VxButtonVariant.primary) {
      button = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(VxRadii.pill),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: VxColors.brandGradient,
          ),
          boxShadow: enabled ? VxShadows.glow : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(VxRadii.pill),
            child: SizedBox(
              height: _height,
              child: Padding(padding: _padding, child: child),
            ),
          ),
        ),
      );
    } else {
      button = Material(
        color: _bg,
        shape: shape,
        child: InkWell(
          onTap: onPressed,
          customBorder: shape,
          child: SizedBox(
            height: _height,
            child: Padding(padding: _padding, child: child),
          ),
        ),
      );
    }

    final wrapped = sized(button);
    return Opacity(opacity: enabled ? 1 : 0.4, child: wrapped);
  }

  Widget sized(Widget child) {
    if (expanded) return SizedBox(width: double.infinity, child: child);
    if (size == VxButtonSize.icon) {
      return SizedBox(width: 40, height: 40, child: child);
    }
    return child;
  }

  Color get _fg => switch (variant) {
        VxButtonVariant.primary => VxColors.ink950,
        VxButtonVariant.danger => Colors.white,
        VxButtonVariant.secondary => Colors.white,
        VxButtonVariant.ghost => VxColors.mist200,
      };

  Color get _bg => switch (variant) {
        VxButtonVariant.primary => Colors.transparent,
        VxButtonVariant.secondary => VxColors.white08,
        VxButtonVariant.ghost => Colors.transparent,
        VxButtonVariant.danger => VxColors.rose.withValues(alpha: 0.9),
      };
}
