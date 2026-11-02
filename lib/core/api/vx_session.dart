import 'package:shared_preferences/shared_preferences.dart';

abstract final class VxSession {
  static const _pref = 'vx.session';
  static String token = '';

  static bool get signedIn => token.trim().isNotEmpty;

  static Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    token = p.getString(_pref) ?? '';
  }

  static Future<void> set(String value) async {
    token = value.trim();
    final p = await SharedPreferences.getInstance();
    await p.setString(_pref, token);
  }

  static Future<void> clear() async {
    token = '';
    final p = await SharedPreferences.getInstance();
    await p.remove(_pref);
  }

  static Map<String, String> headers({Map<String, String>? extra}) => {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        ...?extra,
      };
}
