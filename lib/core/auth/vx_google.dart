import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vortexsales/core/api/vx_api_client.dart';
import 'package:vortexsales/core/api/vx_api_config.dart';

class VxGoogleTokens {
  const VxGoogleTokens({this.idToken, this.accessToken, this.sessionToken});

  final String? idToken;
  final String? accessToken;
  final String? sessionToken;

  bool get hasCredential =>
      (idToken != null && idToken!.isNotEmpty) ||
      (accessToken != null && accessToken!.isNotEmpty) ||
      (sessionToken != null && sessionToken!.isNotEmpty);
}

/// Google sign-in: native tokens when possible, otherwise browser OAuth + deep link.
abstract final class VxGoogleAuth {
  static const _serverClientId = String.fromEnvironment('VX_GOOGLE_SERVER_CLIENT_ID');
  static StreamSubscription<Uri>? _sub;
  static Completer<String?>? _pending;

  static GoogleSignIn get _native => GoogleSignIn(
        scopes: const ['email', 'profile'],
        serverClientId: _serverClientId.trim().isEmpty ? null : _serverClientId.trim(),
      );

  static Future<void> warmDeepLinks() async {
    if (kIsWeb) return;
    _sub ??= AppLinks().uriLinkStream.listen(_onUri);
    try {
      final initial = await AppLinks().getInitialLink();
      if (initial != null) _onUri(initial);
    } catch (_) {
      /* ignore */
    }
  }

  static void _onUri(Uri uri) {
    if (uri.scheme != 'vortexsales') return;
    if (uri.host != 'oauth' && !uri.path.contains('oauth')) return;
    final token = uri.queryParameters['token']?.trim() ?? '';
    if (token.isEmpty) return;
    _pending?.complete(token);
    _pending = null;
  }

  static Future<VxGoogleTokens?> signIn() async {
    // 1) Native Google account picker (Play Services).
    try {
      final account = await _native.signIn();
      if (account != null) {
        final auth = await account.authentication;
        final idToken = auth.idToken?.trim();
        final accessToken = auth.accessToken?.trim();
        if ((idToken != null && idToken.isNotEmpty) ||
            (accessToken != null && accessToken.isNotEmpty)) {
          return VxGoogleTokens(idToken: idToken, accessToken: accessToken);
        }
      }
    } catch (_) {
      /* fall through */
    }

    if (!VxApiConfig.configured) return null;

    // 2) Browser OAuth via AMREKA2 (needs GOOGLE_CLIENT_ID/SECRET on server).
    try {
      final start = await VxApiClient().getJson('${VxApiPaths.auth}/google?mobile=1');
      final url = start['url'] as String? ?? '';
      if (url.isEmpty) return null;
      final completer = Completer<String?>();
      _pending = completer;
      final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      if (!ok) {
        _pending = null;
        return null;
      }
      final session = await completer.future.timeout(
        const Duration(minutes: 3),
        onTimeout: () {
          _pending = null;
          return null;
        },
      );
      if (session == null || session.isEmpty) return null;
      return VxGoogleTokens(sessionToken: session);
    } catch (_) {
      return null;
    }
  }
}
