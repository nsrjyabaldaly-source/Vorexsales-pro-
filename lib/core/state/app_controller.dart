import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/l10n/vx_locales.dart';

enum VxGate { splash, language, howto, login, register, onboarding, app }

class AppController extends ChangeNotifier {
  String localeCode = 'en';
  VxGate gate = VxGate.splash;
  bool languageChosen = false;
  bool loggedIn = false;
  bool onboarded = false;
  bool tutorialDone = false;
  bool coachDone = false;

  Map<String, dynamic> _en = {};
  Map<String, dynamic> _msg = {};

  Locale get locale =>
      localeCode == 'zh-TW' ? const Locale('zh', 'TW') : Locale(localeCode);

  VxLocaleInfo get localeInfo => vxLocaleInfo(localeCode);

  VxL10n get l10n => VxL10n(
        locale: locale,
        info: localeInfo,
        messages: _msg,
        fallback: _en,
      );

  bool get showCoach =>
      tutorialDone && !coachDone && gate == VxGate.app;

  VxGate get _afterHowTo => !loggedIn
      ? VxGate.login
      : !onboarded
          ? VxGate.onboarding
          : VxGate.app;

  Future<void> load() async {
    _en = await VxL10n.loadMessages('en');
    final p = await SharedPreferences.getInstance();
    localeCode = p.getString('vx.locale') ?? 'en';
    if (vxLocales.every((l) => l.code != localeCode)) localeCode = 'en';
    _msg = localeCode == 'en' ? _en : await VxL10n.loadMessages(localeCode);
    languageChosen = p.getBool('vx.language') ?? false;
    loggedIn = p.getBool('vx.loggedIn') ?? false;
    onboarded = p.getBool('vx.onboarded') ?? false;
    tutorialDone = p.getBool('vx.tutorial') ?? false;
    coachDone = p.getBool('vx.coach') ?? false;
    gate = !languageChosen
        ? VxGate.language
        : !tutorialDone
            ? VxGate.howto
            : !loggedIn
                ? VxGate.login
                : !onboarded
                    ? VxGate.onboarding
                    : VxGate.app;
    notifyListeners();
  }

  Future<void> setLocale(String code) async {
    localeCode = code;
    _msg = code == 'en' ? _en : await VxL10n.loadMessages(code);
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setString('vx.locale', code);
  }

  Future<void> completeLanguage() async {
    languageChosen = true;
    gate = VxGate.howto;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('vx.language', true);
  }

  Future<void> completeHowTo() async {
    tutorialDone = true;
    coachDone = false;
    gate = _afterHowTo;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('vx.tutorial', true);
    await p.setBool('vx.coach', false);
  }

  Future<void> replayHowTo() async {
    tutorialDone = false;
    coachDone = false;
    gate = VxGate.howto;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('vx.tutorial', false);
    await p.setBool('vx.coach', false);
  }

  Future<void> completeCoach() async {
    coachDone = true;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('vx.coach', true);
  }

  Future<void> openRegister() async {
    gate = VxGate.register;
    notifyListeners();
  }

  Future<void> openLogin() async {
    gate = VxGate.login;
    notifyListeners();
  }

  Future<void> login({bool demo = false}) async {
    loggedIn = true;
    if (demo) onboarded = true;
    gate = demo || onboarded ? VxGate.app : VxGate.onboarding;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('vx.loggedIn', true);
    if (demo) await p.setBool('vx.onboarded', true);
  }

  Future<void> register() async {
    loggedIn = true;
    gate = VxGate.onboarding;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('vx.loggedIn', true);
  }

  Future<void> completeOnboarding() async {
    onboarded = true;
    gate = VxGate.app;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('vx.onboarded', true);
  }
}

class VxScope extends InheritedNotifier<AppController> {
  const VxScope({
    super.key,
    required AppController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VxScope>()!.notifier!;
}
