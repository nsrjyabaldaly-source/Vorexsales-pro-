import 'package:flutter/material.dart';
import 'package:vortexsales/core/brand/vortex_wordmark.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/state/app_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';

class MoreSheet extends StatelessWidget {
  const MoreSheet({super.key, required this.onOpen});

  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final items = [
      (Icons.auto_awesome_outlined, t.playground, 4),
      (Icons.menu_book_outlined, t.knowledge, 5),
      (Icons.inventory_2_outlined, t.catalog, 6),
      (Icons.people_outline, t.leads, 7),
      (Icons.settings_outlined, t.settings, 8),
    ];

    return VxGlass(
      radius: 28,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const VortexWordmark(),
          const SizedBox(height: 6),
          Text(t.moreMenu, style: const TextStyle(fontSize: 13, color: VxColors.mist400)),
          const SizedBox(height: 16),
          ...items.map(
            (item) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(item.$1, color: VxColors.mist300),
              title: Text(item.$2, style: const TextStyle(color: Colors.white)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(VxRadii.input),
              ),
              onTap: () {
                Navigator.pop(context);
                onOpen(item.$3);
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.menu_book_outlined, color: VxColors.mist300),
            title: Text(t.replay, style: const TextStyle(color: Colors.white)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(VxRadii.input),
            ),
            onTap: () {
              final app = VxScope.of(context);
              Navigator.pop(context);
              app.replayHowTo();
            },
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(VxRadii.input),
              gradient: LinearGradient(
                colors: [
                  VxColors.cyan.withValues(alpha: 0.15),
                  VxColors.violet.withValues(alpha: 0.15),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.quota(41),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  t.quotaUsed('2,048', '5,000'),
                  style: const TextStyle(fontSize: 12, color: VxColors.mist300),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: const LinearProgressIndicator(
                    value: 0.41,
                    minHeight: 6,
                    backgroundColor: Color(0x1AFFFFFF),
                    valueColor: AlwaysStoppedAnimation(VxColors.cyan),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
