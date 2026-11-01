import 'package:flutter/material.dart';
import 'package:vortexsales/core/state/app_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/features/first_run/language_screen.dart';

class LocaleChip extends StatelessWidget {
  const LocaleChip({super.key});

  @override
  Widget build(BuildContext context) {
    final app = VxScope.of(context);
    return Material(
      color: Colors.transparent,
      shape: const StadiumBorder(side: BorderSide(color: VxColors.hairline)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute<void>(
              builder: (_) => const LanguageScreen(asOverlay: true),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            app.localeInfo.native,
            style: const TextStyle(fontSize: 12, color: VxColors.mist200),
          ),
        ),
      ),
    );
  }
}
