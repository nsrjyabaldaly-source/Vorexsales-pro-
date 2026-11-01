import 'package:flutter/material.dart';
import 'package:vortexsales/core/brand/vortex_wordmark.dart';
import 'package:vortexsales/core/state/app_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/core/widgets/vx_button.dart';
import 'package:vortexsales/core/widgets/vx_field.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';
import 'package:vortexsales/core/widgets/vx_scaffold.dart';
import 'package:vortexsales/features/auth/locale_chip.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  String _kind = 'clinic';
  final _name = TextEditingController(text: 'Luna Dental');
  String _tz = 'Asia/Dubai';

  static const embed =
      '<script src="https://vortexsales.app/embed.js" data-key="pk_luna_live"></script>';

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = VxScope.of(context);
    final t = app.l10n;
    final types = [
      ('clinic', t.clinic, 'عيادة وعافية'),
      ('retail', t.retail, 'تجزئة'),
      ('services', t.services, 'خدمات'),
      ('property', t.property, 'عقار'),
    ];

    return VxScaffold(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      body: ListView(
        children: [
          const Row(
            children: [
              VortexWordmark(),
              Spacer(),
              LocaleChip(),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            t.stepOf(_step + 1).toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              letterSpacing: 2.16,
              color: VxColors.cyan,
            ),
          ),
          const SizedBox(height: 12),
          Text(t.onboardTitle, style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 24),
          VxGlass(
            radius: 27,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_step == 0) ...[
                  Text(t.sellType, style: const TextStyle(fontSize: 14, color: VxColors.mist300)),
                  const SizedBox(height: 12),
                  ...types.map((item) {
                    final active = _kind == item.$1;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: active
                            ? VxColors.cyan.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(VxRadii.input),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(VxRadii.input),
                          onTap: () => setState(() => _kind = item.$1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(VxRadii.input),
                              border: Border.all(color: VxColors.hairline),
                            ),
                            child: Text.rich(
                              TextSpan(
                                text: item.$2,
                                style: const TextStyle(fontSize: 14, color: Colors.white),
                                children: [
                                  TextSpan(
                                    text: '  ${item.$3}',
                                    style: const TextStyle(color: VxColors.mist500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
                if (_step == 1) ...[
                  Text(t.profile, style: const TextStyle(fontSize: 14, color: VxColors.mist300)),
                  const SizedBox(height: 16),
                  VxField(label: t.businessName, child: VxTextField(controller: _name)),
                  const SizedBox(height: 16),
                  VxField(
                    label: t.timezone,
                    child: DropdownButtonFormField<String>(
                      initialValue: _tz,
                      dropdownColor: VxColors.ink800,
                      items: const [
                        'Asia/Dubai',
                        'Europe/Stockholm',
                        'Europe/Lisbon',
                        'America/New_York',
                        'Asia/Tokyo',
                      ].map((z) => DropdownMenuItem(value: z, child: Text(z))).toList(),
                      onChanged: (v) => setState(() => _tz = v ?? _tz),
                    ),
                  ),
                ],
                if (_step == 2) ...[
                  Text(t.hours, style: const TextStyle(fontSize: 14, color: VxColors.mist300)),
                  const SizedBox(height: 16),
                  const Text('Sun 10:00–18:00', style: TextStyle(color: VxColors.mist200)),
                  const SizedBox(height: 8),
                  const Text('Mon–Thu 09:00–21:00', style: TextStyle(color: VxColors.mist200)),
                  const SizedBox(height: 8),
                  const Text('Fri 14:00–20:00', style: TextStyle(color: VxColors.mist200)),
                  const SizedBox(height: 8),
                  const Text('Sat closed', style: TextStyle(color: VxColors.mist200)),
                ],
                if (_step == 3) ...[
                  Text(t.goLive, style: const TextStyle(fontSize: 14, color: VxColors.mist300)),
                  const SizedBox(height: 8),
                  Text(t.snippet, style: const TextStyle(fontSize: 12, color: VxColors.mist500)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: VxColors.ink950,
                      borderRadius: BorderRadius.circular(VxRadii.input),
                    ),
                    child: const SelectableText(
                      embed,
                      style: TextStyle(fontSize: 11, color: VxColors.cyan),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_name.text} · $_tz · $_kind',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
                const SizedBox(height: 28),
                Row(
                  children: [
                    TextButton(
                      onPressed: _step == 0 ? null : () => setState(() => _step--),
                      child: Text(
                        t.back,
                        style: TextStyle(
                          color: VxColors.mist400.withValues(alpha: _step == 0 ? 0.3 : 1),
                        ),
                      ),
                    ),
                    const Spacer(),
                    VxButton(
                      label: _step == 3 ? t.finish : t.next,
                      onPressed: () {
                        if (_step == 3) {
                          app.completeOnboarding();
                        } else {
                          setState(() => _step++);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
