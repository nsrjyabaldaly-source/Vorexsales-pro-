import 'package:shared_preferences/shared_preferences.dart';

/// Optional remote push hook.
/// Wire Firebase Messaging when `google-services.json` / Apple push are present.
/// Until then, [VxNotify] local alerts + polling cover inbox/bookings.
abstract final class VxPush {
  static const _tokenPref = 'vx.fcmToken';

  static Future<String?> savedToken() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_tokenPref);
  }

  static Future<void> saveToken(String token) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_tokenPref, token.trim());
  }

  /// No-op scaffold — returns false until Firebase is configured in the project.
  static Future<bool> initIfAvailable() async {
    // Intentionally empty: adding firebase_core without platform files breaks builds.
    // When ready:
    // 1) flutterfire configure
    // 2) add firebase_messaging
    // 3) request permission + saveToken(await messaging.getToken())
    return false;
  }
}
