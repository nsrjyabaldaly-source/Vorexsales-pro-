import 'package:flutter/material.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/widgets/vx_button.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';

class VxStoreForm extends StatelessWidget {
  const VxStoreForm({
    super.key,
    required this.children,
    required this.onSave,
    required this.onCancel,
  });

  final List<Widget> children;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    return VxGlass(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ...[
            for (final child in children) ...[child, const SizedBox(height: 12)],
          ],
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: onCancel,
                child: Text(t.cancel, style: const TextStyle(color: VxColors.mist400)),
              ),
              const SizedBox(width: 8),
              VxButton(label: t.save, onPressed: onSave),
            ],
          ),
        ],
      ),
    );
  }
}

class VxRowActions extends StatelessWidget {
  const VxRowActions({super.key, required this.onEdit, required this.onRemove});

  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    return Row(
      children: [
        TextButton(
          onPressed: onEdit,
          child: Text(t.edit, style: const TextStyle(fontSize: 12, color: VxColors.cyan)),
        ),
        TextButton(
          onPressed: onRemove,
          child: Text(t.remove, style: const TextStyle(fontSize: 12, color: VxColors.violetGlow)),
        ),
      ],
    );
  }
}
