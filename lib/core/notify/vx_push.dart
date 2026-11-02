import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vortexsales/core/api/vx_api_client.dart';
import 'package:vortexsales/core/api/vx_api_config.dart';

/// Optional remote push hook.
///
/// Full FCM needs `flutterfire configure` + `firebase_core` / `firebase_messaging`
/// and platform config files. Until those exist this still:
/// 1) keeps any manually saved device token
/// 2) registers that token with `/api/devices` when the user is signed in
abstract final class VxPush {
  static const _tokenPref = 'vx.fcmToken';
  static const _platformPref = 'vx.fcmPlatform';

  static Future<String?> savedToken() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_tokenPref);
  }

  static Future<void> saveToken(String token, {String? platform}) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_tokenPref, token.trim());
    if (platform != null && platform.trim().isNotEmpty) {
      await p.setString(_platformPref, platform.trim());
    }
  }

  static String _guessPlatform() {
    if (kIsWeb) return 'web';
    try {
      if (Platform.isIOS) return 'ios';
      if (Platform.isAndroid) return 'android';
    } catch (_) {
      /* platform unavailable */
    }
    return 'unknown';
  }

  /// Register the current token with AMREKA2 (auth required).
  static Future<bool> syncTokenToServer() async {
    if (!VxApiConfig.configured) return false;
    final token = await savedToken();
    if (token == null || token.isEmpty) return false;
    final p = await SharedPreferences.getInstance();
    final platform = p.getString(_platformPref) ?? _guessPlatform();
    try {
      await VxApiClient().sendJson(
        VxApiPaths.devices,
        method: 'POST',
        body: {'token': token, 'platform': platform},
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Returns true when a device token is present (manual or future FCM).
  /// Does not pull in Firebase packages — those break builds without config files.
  static Future<bool> initIfAvailable() async {
    final existing = await savedToken();
    if (existing != null && existing.isNotEmpty) {
      await syncTokenToServer();
      return true;
    }
    // When Firebase is wired, replace this block with:
    // final messaging = FirebaseMessaging.instance;
    // await messaging.requestPermission();
    // final token = await messaging.getToken();
    // if (token != null) { await saveToken(token); await syncTokenToServer(); }
    return false;
  }
}
