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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController(text: 'Muhanad Vortex');
  final _email = TextEditingController(text: 'muhanad@vortex.llc');
  final _password = TextEditingController(text: '••••••••');

  @override
  void dispose() {
    _name.dispose();
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
          const Row(
            children: [
              VortexWordmark(),
              Spacer(),
              LocaleChip(),
            ],
          ),
          const SizedBox(height: 36),
          VxGlass(
            radius: VxRadii.cardLg,
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(t.signUpTitle, style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 8),
                Text(t.signUpBody, style: const TextStyle(fontSize: 14, color: VxColors.mist400)),
                const SizedBox(height: 28),
                VxField(label: t.fullName, child: VxTextField(controller: _name)),
                const SizedBox(height: 16),
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
                VxButton(
                  label: t.createAccount,
                  expanded: true,
                  size: VxButtonSize.lg,
                  onPressed: app.register,
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(t.hasAccount, style: const TextStyle(fontSize: 14, color: VxColors.mist400)),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: app.openLogin,
                      child: Text(
                        t.login,
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
