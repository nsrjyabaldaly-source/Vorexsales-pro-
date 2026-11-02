import 'package:flutter/material.dart';
import 'package:vortexsales/core/brand/vortex_mark.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/state/app_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/features/auth/locale_chip.dart';

class AppTopbar extends StatelessWidget {
  const AppTopbar({
    super.key,
    required this.search,
    this.onClear,
  });

  final TextEditingController search;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final app = VxScope.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: VxColors.hairline)),
      ),
      child: Row(
        children: [
          const VortexMark.lockup(),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 40,
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: search,
                builder: (context, value, _) {
                  return TextField(
                    controller: search,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: t.search,
                      filled: true,
                      fillColor: VxColors.white05,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(VxRadii.pill),
                        borderSide: const BorderSide(color: VxColors.hairline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(VxRadii.pill),
                        borderSide: const BorderSide(color: VxColors.hairline),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(VxRadii.pill),
                        borderSide: BorderSide(
                          color: VxColors.cyan.withValues(alpha: 0.5),
                        ),
                      ),
                      suffixIcon: value.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: onClear,
                              icon: const Icon(
                                Icons.close,
                                size: 16,
                                color: VxColors.mist400,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            tooltip: t.replay,
            onPressed: app.replayHowTo,
            icon: const Icon(
              Icons.menu_book_outlined,
              size: 20,
              color: VxColors.mist200,
            ),
          ),
          const LocaleChip(),
        ],
      ),
    );
  }
}
