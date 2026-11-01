import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vortexsales/core/brand/brand.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/l10n/vx_locales.dart';
import 'package:vortexsales/core/state/app_controller.dart';
import 'package:vortexsales/core/state/store_controller.dart';
import 'package:vortexsales/core/theme/vx_theme.dart';
import 'package:vortexsales/features/auth/login_screen.dart';
import 'package:vortexsales/features/auth/register_screen.dart';
import 'package:vortexsales/features/first_run/language_screen.dart';
import 'package:vortexsales/features/first_run/splash_screen.dart';
import 'package:vortexsales/features/first_run/tutorial_screen.dart';
import 'package:vortexsales/features/onboarding/onboarding_screen.dart';
import 'package:vortexsales/features/shell/app_shell.dart';

class VxApp extends StatelessWidget {
  const VxApp({
    super.key,
    required this.controller,
    required this.store,
  });

  final AppController controller;
  final StoreController store;

  @override
  Widget build(BuildContext context) {
    return VxScope(
      controller: controller,
      child: StoreScope(
        store: store,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final l10n = controller.l10n;
            return MaterialApp(
              title: Brand.name,
              debugShowCheckedModeBanner: false,
              locale: controller.locale,
              supportedLocales: [
                for (final l in vxLocales)
                  l.code == 'zh-TW' ? const Locale('zh', 'TW') : Locale(l.code),
              ],
              localeListResolutionCallback: (locales, supported) =>
                  controller.locale,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: VxTheme.dark(controller.locale),
              builder: (context, child) {
                return VxL10nHost(
                  l10n: l10n,
                  child: Directionality(
                    textDirection: l10n.direction,
                    child: child ?? const SizedBox.shrink(),
                  ),
                );
              },
              home: switch (controller.gate) {
                VxGate.splash => const SplashScreen(),
                VxGate.language => const LanguageScreen(),
                VxGate.howto => const TutorialScreen(),
                VxGate.login => const LoginScreen(),
                VxGate.register => const RegisterScreen(),
                VxGate.onboarding => const OnboardingScreen(),
                VxGate.app => const AppShell(),
              },
            );
          },
        ),
      ),
    );
  }
}
