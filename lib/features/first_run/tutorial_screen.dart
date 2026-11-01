import 'package:flutter/material.dart';
import 'package:vortexsales/core/brand/vortex_wordmark.dart';
import 'package:vortexsales/core/state/app_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/widgets/vx_button.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';
import 'package:vortexsales/core/widgets/vx_scaffold.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  static const _steps = [
    ('s1', Icons.dashboard_outlined),
    ('s2', Icons.chat_bubble_outline),
    ('s3', Icons.menu_book_outlined),
    ('s4', Icons.auto_awesome_outlined),
    ('s5', Icons.power_settings_new),
  ];

  int _step = 0;

  @override
  Widget build(BuildContext context) {
    final app = VxScope.of(context);
    final t = app.l10n;
    final current = _steps[_step];
    final last = _step == _steps.length - 1;

    return VxScaffold(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const VortexWordmark(),
              const Spacer(),
              TextButton(
                onPressed: app.completeHowTo,
                child: Text(
                  t.howtoSkip,
                  style: const TextStyle(color: VxColors.mist400, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            t.howtoStep(_step + 1, _steps.length).toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              letterSpacing: 2.16,
              color: VxColors.cyan,
            ),
            textDirection: TextDirection.ltr,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: VxGlass(
              radius: 28.8,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: VxColors.cyan.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(current.$2, color: VxColors.cyan),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    t.howtoTitle(current.$1),
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t.howtoBody(current.$1),
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.55,
                      color: VxColors.mist300,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < _steps.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 6,
                          width: i == _step ? 24 : 8,
                          decoration: BoxDecoration(
                            color: i == _step ? VxColors.cyan : Colors.white24,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              TextButton(
                onPressed: _step == 0 ? null : () => setState(() => _step--),
                child: Text(
                  t.howtoBack,
                  style: TextStyle(
                    color: VxColors.mist400.withValues(alpha: _step == 0 ? 0.3 : 1),
                  ),
                ),
              ),
              const Spacer(),
              VxButton(
                label: last ? t.howtoStart : t.howtoNext,
                onPressed: () {
                  if (last) {
                    app.completeHowTo();
                  } else {
                    setState(() => _step++);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
