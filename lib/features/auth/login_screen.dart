import 'package:flutter/material.dart';
import 'package:vortexsales/core/brand/vortex_wordmark.dart';
import 'package:vortexsales/core/state/app_controller.dart';
import 'package:vortexsales/core/state/store_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/core/widgets/vx_button.dart';
import 'package:vortexsales/core/widgets/vx_field.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';
import 'package:vortexsales/core/widgets/vx_scaffold.dart';
import 'package:vortexsales/features/auth/locale_chip.dart';

/// Polished auth gate: social first, then email continue (login or create).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  var _showEmail = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _afterOk() async {
    if (!mounted) return;
    final app = VxScope.of(context);
    await StoreScope.of(context).load(demo: app.demoWorkspace);
  }

  Future<void> _social(Future<String?> Function() run) async {
    final err = await run();
    if (!mounted || err != null) return;
    await _afterOk();
  }

  Future<void> _emailContinue() async {
    final app = VxScope.of(context);
    final err = await app.continueWithEmail(
      email: _email.text,
      password: _password.text,
    );
    if (!mounted || err != null) return;
    await _afterOk();
  }

  Future<void> _demo() async {
    final app = VxScope.of(context);
    final err = await app.login(demo: true);
    if (!mounted || err != null) return;
    await _afterOk();
  }

  @override
  Widget build(BuildContext context) {
    final app = VxScope.of(context);
    final t = app.l10n;
    final ar = t.isAr;
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
          const SizedBox(height: 28),
          VxGlass(
            radius: VxRadii.cardLg,
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  ar ? 'ادخل بضغطة واحدة' : 'Sign in in one tap',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  ar
                      ? 'جوجل أو فيسبوك أو بريدك — بدون تعقيد.'
                      : 'Google, Facebook, or email — no friction.',
                  style: const TextStyle(fontSize: 14, height: 1.45, color: VxColors.mist400),
                ),
                const SizedBox(height: 24),
                VxButton(
                  label: ar ? 'المتابعة مع Google' : 'Continue with Google',
                  icon: Icons.g_mobiledata_rounded,
                  expanded: true,
                  size: VxButtonSize.lg,
                  onPressed: app.authBusy ? null : () => _social(app.loginWithGoogle),
                ),
                const SizedBox(height: 10),
                VxButton(
                  label: ar ? 'المتابعة مع Facebook' : 'Continue with Facebook',
                  icon: Icons.facebook_rounded,
                  variant: VxButtonVariant.secondary,
                  expanded: true,
                  size: VxButtonSize.lg,
                  onPressed: app.authBusy ? null : () => _social(app.loginWithFacebook),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Expanded(child: Divider(color: VxColors.hairline)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        t.or.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          letterSpacing: 2,
                          color: VxColors.mist500,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: VxColors.hairline)),
                  ],
                ),
                const SizedBox(height: 16),
                if (!_showEmail)
                  VxButton(
                    label: ar ? 'المتابعة بالبريد' : 'Continue with email',
                    icon: Icons.mail_outline_rounded,
                    variant: VxButtonVariant.secondary,
                    expanded: true,
                    size: VxButtonSize.lg,
                    onPressed: app.authBusy ? null : () => setState(() => _showEmail = true),
                  )
                else ...[
                  VxField(
                    label: t.email,
                    child: VxTextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 12),
                  VxField(
                    label: t.password,
                    child: VxTextField(controller: _password, obscure: true),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ar
                        ? 'حساب جديد؟ اكتب بريداً وكلمة مرور (6 أحرف+) واضغط متابعة.'
                        : 'New here? Enter email + password (6+ chars) and continue.',
                    style: const TextStyle(fontSize: 12, height: 1.4, color: VxColors.mist500),
                  ),
                  const SizedBox(height: 14),
                  VxButton(
                    label: ar ? 'متابعة' : 'Continue',
                    expanded: true,
                    size: VxButtonSize.lg,
                    onPressed: app.authBusy ? null : _emailContinue,
                  ),
                ],
                if (app.authError != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: VxColors.violet.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(VxRadii.input),
                      border: Border.all(color: VxColors.violet.withValues(alpha: 0.35)),
                    ),
                    child: Text(
                      app.authError!,
                      style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.white),
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                TextButton(
                  onPressed: app.authBusy ? null : _demo,
                  child: Text(
                    ar ? 'تجربة سريعة بدون حساب' : 'Quick demo without an account',
                    style: const TextStyle(fontSize: 13, color: VxColors.cyan),
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
