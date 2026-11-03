import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vortexsales/core/api/vx_api_client.dart';
import 'package:vortexsales/core/api/vx_api_config.dart';
import 'package:vortexsales/core/api/vx_session.dart';
import 'package:vortexsales/core/auth/vx_google.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/l10n/vx_locales.dart';
import 'package:vortexsales/core/notify/vx_push.dart';

enum VxGate { splash, language, howto, login, register, onboarding, app }

class AppController extends ChangeNotifier {
  String localeCode = 'en';
  VxGate gate = VxGate.splash;
  bool languageChosen = false;
  bool loggedIn = false;
  bool onboarded = false;
  bool tutorialDone = false;
  bool coachDone = false;
  bool authBusy = false;
  String? authError;
  bool sessionExpired = false;
  bool demoWorkspace = false;

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
    demoWorkspace = p.getBool('vx.demo') ?? false;
    onboarded = p.getBool('vx.onboarded') ?? false;
    tutorialDone = p.getBool('vx.tutorial') ?? false;
    coachDone = p.getBool('vx.coach') ?? false;
    if (loggedIn) {
      await _validateSession();
    }
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

  /// Confirms the bearer token with GET /api/auth. Soft-fails offline.
  Future<void> _validateSession() async {
    if (!VxApiConfig.configured || !VxSession.signedIn) {
      if (loggedIn && !VxSession.signedIn) {
        loggedIn = false;
        final p = await SharedPreferences.getInstance();
        await p.setBool('vx.loggedIn', false);
      }
      return;
    }
    try {
      await VxApiClient().getJson(VxApiPaths.auth);
    } on VxApiException catch (e) {
      if (e.status == 401) {
        await markSessionExpired();
      }
    } catch (_) {
      // Keep local session when the server is unreachable.
    }
  }

  Future<void> markSessionExpired() async {
    await VxSession.clear();
    loggedIn = false;
    sessionExpired = true;
    demoWorkspace = false;
    gate = VxGate.login;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('vx.loggedIn', false);
    await p.setBool('vx.demo', false);
  }

  Future<void> logout() async {
    authBusy = true;
    notifyListeners();
    if (VxApiConfig.configured && VxSession.signedIn) {
      try {
        await VxApiClient().sendJson(
          VxApiPaths.auth,
          method: 'POST',
          body: {'action': 'logout'},
        );
      } catch (_) {
        // Clear local state even if the server call fails.
      }
    }
    await VxSession.clear();
    loggedIn = false;
    sessionExpired = false;
    demoWorkspace = false;
    gate = VxGate.login;
    authBusy = false;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('vx.loggedIn', false);
    await p.setBool('vx.demo', false);
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

  Future<String?> login({
    bool demo = false,
    String email = '',
    String password = '',
  }) async {
    authBusy = true;
    authError = null;
    notifyListeners();
    if (VxApiConfig.configured) {
      try {
        final json = await VxApiClient().sendJson(
          VxApiPaths.auth,
          method: 'POST',
          body: demo
              ? {'demo': true}
              : {'email': email.trim(), 'password': password},
        );
        final token = json['token'] as String? ?? '';
        if (token.isEmpty) throw VxApiException('no session');
        await VxSession.set(token);
      } catch (e) {
        authBusy = false;
        authError = e.toString();
        notifyListeners();
        return authError;
      }
    }
    return _finishLogin(demo: demo);
  }

  Future<String?> loginWithGoogle() async {
    authBusy = true;
    authError = null;
    notifyListeners();
    try {
      final creds = await VxGoogleAuth.signIn();
      if (creds == null || !creds.hasCredential) {
        throw VxApiException('Google sign-in cancelled');
      }
      if (creds.sessionToken != null && creds.sessionToken!.isNotEmpty) {
        await VxSession.set(creds.sessionToken!);
      } else {
        final json = await VxApiClient().sendJson(
          VxApiPaths.auth,
          method: 'POST',
          body: {
            'action': 'google',
            if (creds.idToken != null && creds.idToken!.isNotEmpty)
              'idToken': creds.idToken,
            if (creds.accessToken != null && creds.accessToken!.isNotEmpty)
              'accessToken': creds.accessToken,
          },
        );
        final token = json['token'] as String? ?? '';
        if (token.isEmpty) throw VxApiException('no session');
        await VxSession.set(token);
      }
    } catch (e) {
      authBusy = false;
      authError = e.toString();
      notifyListeners();
      return authError;
    }
    return _finishLogin(demo: false);
  }

  Future<String?> _finishLogin({required bool demo}) async {
    loggedIn = true;
    sessionExpired = false;
    demoWorkspace = demo;
    if (demo) onboarded = true;
    gate = demo || onboarded ? VxGate.app : VxGate.onboarding;
    authBusy = false;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('vx.loggedIn', true);
    await p.setBool('vx.demo', demo);
    if (demo) await p.setBool('vx.onboarded', true);
    // ignore: unawaited_futures
    VxPush.syncTokenToServer();
    return null;
  }

  Future<String?> register({
    String name = '',
    String email = '',
    String password = '',
  }) async {
    authBusy = true;
    authError = null;
    notifyListeners();
    if (VxApiConfig.configured) {
      try {
        final json = await VxApiClient().sendJson(
          VxApiPaths.auth,
          method: 'POST',
          body: {
            'action': 'register',
            'name': name.trim(),
            'email': email.trim(),
            'password': password,
          },
        );
        final token = json['token'] as String? ?? '';
        if (token.isEmpty) throw VxApiException('no session');
        await VxSession.set(token);
      } catch (e) {
        authBusy = false;
        authError = e.toString();
        notifyListeners();
        return authError;
      }
    }
    loggedIn = true;
    sessionExpired = false;
    demoWorkspace = false;
    gate = VxGate.onboarding;
    authBusy = false;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('vx.loggedIn', true);
    await p.setBool('vx.demo', false);
    return null;
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
