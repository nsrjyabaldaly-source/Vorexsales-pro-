import 'package:flutter/material.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';

class MobileNav extends StatelessWidget {
  const MobileNav({
    super.key,
    required this.index,
    required this.onSelect,
    required this.onMore,
    this.inboxKey,
    this.channelsKey,
  });

  final int index;
  final ValueChanged<int> onSelect;
  final VoidCallback onMore;
  final GlobalKey? inboxKey;
  final GlobalKey? channelsKey;

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final items = [
      (Icons.dashboard_outlined, t.overview),
      (Icons.chat_bubble_outline, t.inbox),
      (Icons.share_outlined, t.channels),
      (Icons.calendar_month_outlined, t.bookings),
    ];
    return Material(
      color: VxColors.ink950.withValues(alpha: 0.95),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: VxColors.hairline)),
        ),
        padding: EdgeInsets.only(
          top: 8,
          bottom: MediaQuery.paddingOf(context).bottom + 8,
        ),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: _NavItem(
                  key: i == 1
                      ? inboxKey
                      : i == 2
                          ? channelsKey
                          : null,
                  icon: items[i].$1,
                  label: items[i].$2,
                  active: index == i,
                  onTap: () => onSelect(i),
                ),
              ),
            Expanded(
              child: _NavItem(
                icon: Icons.more_horiz,
                label: t.more,
                active: index >= 4,
                onTap: onMore,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(VxRadii.input),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: active ? VxColors.white08 : Colors.transparent,
                borderRadius: BorderRadius.circular(VxRadii.input),
              ),
              child: Icon(
                icon,
                size: 20,
                color: active ? VxColors.cyan : VxColors.mist400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                color: active ? VxColors.cyan : VxColors.mist500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
