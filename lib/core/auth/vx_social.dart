import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vortexsales/core/api/vx_api_client.dart';
import 'package:vortexsales/core/api/vx_api_config.dart';

class VxSocialResult {
  const VxSocialResult({
    this.idToken,
    this.accessToken,
    this.sessionToken,
    this.provider = 'google',
  });

  final String? idToken;
  final String? accessToken;
  final String? sessionToken;
  final String provider;

  bool get ok =>
      (sessionToken != null && sessionToken!.isNotEmpty) ||
      (idToken != null && idToken!.isNotEmpty) ||
      (accessToken != null && accessToken!.isNotEmpty);
}

/// Social sign-in used by the polished login screen.
abstract final class VxSocialAuth {
  static const _serverClientId = String.fromEnvironment('VX_GOOGLE_SERVER_CLIENT_ID');
  static StreamSubscription<Uri>? _sub;
  static Completer<String?>? _pending;
  static var _warmed = false;

  static GoogleSignIn get _google => GoogleSignIn(
        scopes: const ['email', 'profile'],
        serverClientId: _serverClientId.trim().isEmpty ? null : _serverClientId.trim(),
      );

  static Future<void> warmDeepLinks() async {
    if (kIsWeb || _warmed) return;
    _warmed = true;
    _sub ??= AppLinks().uriLinkStream.listen(_onUri);
    try {
      final initial = await AppLinks().getInitialLink();
      if (initial != null) _onUri(initial);
    } catch (_) {}
  }

  static void _onUri(Uri uri) {
    if (uri.scheme != 'vortexsales') return;
    if (uri.host != 'oauth' && !uri.path.contains('oauth')) return;
    final token = uri.queryParameters['token']?.trim() ?? '';
    if (token.isEmpty) return;
    _pending?.complete(token);
    _pending = null;
  }

  static Future<String?> _browserOAuth(String path) async {
    if (!VxApiConfig.configured) return null;
    final start = await VxApiClient().getJson(path);
    final url = start['url'] as String? ?? '';
    if (url.isEmpty) return null;
    final completer = Completer<String?>();
    _pending = completer;
    final launched = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    if (!launched) {
      _pending = null;
      return null;
    }
    return completer.future.timeout(
      const Duration(minutes: 3),
      onTimeout: () {
        _pending = null;
        return null;
      },
    );
  }

  static Future<VxSocialResult?> google() async {
    try {
      final account = await _google.signIn();
      if (account != null) {
        final auth = await account.authentication;
        final idToken = auth.idToken?.trim();
        final accessToken = auth.accessToken?.trim();
        if ((idToken != null && idToken.isNotEmpty) ||
            (accessToken != null && accessToken.isNotEmpty)) {
          return VxSocialResult(
            idToken: idToken,
            accessToken: accessToken,
            provider: 'google',
          );
        }
      }
    } catch (_) {}

    final session = await _browserOAuth('${VxApiPaths.auth}/google?mobile=1');
    if (session == null || session.isEmpty) return null;
    return VxSocialResult(sessionToken: session, provider: 'google');
  }

  static Future<VxSocialResult?> facebook() async {
    final session = await _browserOAuth('${VxApiPaths.auth}/facebook?mobile=1');
    if (session == null || session.isEmpty) return null;
    return VxSocialResult(sessionToken: session, provider: 'facebook');
  }
}
