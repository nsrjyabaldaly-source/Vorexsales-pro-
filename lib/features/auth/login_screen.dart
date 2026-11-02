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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController(text: 'muhanad@vortex.llc');
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = VxScope.of(context);
    final t = app.l10n;
    return VxScaffold(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      body: ListView(
        children: [
          Row(
            children: [
              const VortexWordmark(),
              const Spacer(),
              const LocaleChip(),
            ],
          ),
          const SizedBox(height: 36),
          VxGlass(
            radius: VxRadii.cardLg,
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(t.signInTitle, style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 8),
                Text(t.signInBody, style: const TextStyle(fontSize: 14, color: VxColors.mist400)),
                const SizedBox(height: 28),
                VxField(
                  label: t.email,
                  child: VxTextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 16),
                VxField(
                  label: t.password,
                  child: VxTextField(controller: _password, obscure: true),
                ),
                const SizedBox(height: 20),
                if (app.authError != null) ...[
                  Text(
                    t.signInBody,
                    style: const TextStyle(fontSize: 13, color: VxColors.violet),
                  ),
                  const SizedBox(height: 12),
                ],
                VxButton(
                  label: t.continueLabel,
                  expanded: true,
                  size: VxButtonSize.lg,
                  onPressed: app.authBusy
                      ? null
                      : () => app.login(
                            email: _email.text,
                            password: _password.text,
                          ),
                ),
                const SizedBox(height: 20),
                Text(
                  t.or.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    letterSpacing: 3,
                    color: VxColors.mist500,
                  ),
                ),
                const SizedBox(height: 16),
                VxButton(
                  label: t.demo,
                  variant: VxButtonVariant.secondary,
                  expanded: true,
                  size: VxButtonSize.lg,
                  onPressed: app.authBusy ? null : () => app.login(demo: true),
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(t.noAccount, style: const TextStyle(fontSize: 14, color: VxColors.mist400)),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: app.openRegister,
                      child: Text(
                        t.createAccount,
                        style: const TextStyle(fontSize: 14, color: VxColors.cyan),
                      ),
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
