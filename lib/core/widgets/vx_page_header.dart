import 'package:flutter/material.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/widgets/vx_button.dart';

class VxPageHeader extends StatelessWidget {
  const VxPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.note,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? note;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.displayMedium),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: const TextStyle(fontSize: 14, color: VxColors.mist400),
          ),
        ],
        if (note != null) ...[
          const SizedBox(height: 8),
          Text(note!, style: const TextStyle(fontSize: 12, color: VxColors.cyan)),
        ],
        if (actionLabel != null) ...[
          const SizedBox(height: 14),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: VxButton(label: actionLabel!, onPressed: onAction),
          ),
        ],
      ],
    );
  }
}
