import 'package:shared_preferences/shared_preferences.dart';

/// Public web origin only. AI keys stay on the AMREKA2 server.
abstract final class VxApiConfig {
  static const defined = String.fromEnvironment('VX_API_BASE');
  static const fallback = 'http://127.0.0.1:3002';
  static const _pref = 'vx.apiBase';

  static String baseUrl = defined;

  static bool get configured => baseUrl.trim().isNotEmpty;

  static Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final saved = p.getString(_pref)?.trim() ?? '';
    if (saved.isNotEmpty) {
      baseUrl = saved;
    } else if (defined.trim().isNotEmpty) {
      baseUrl = defined.trim();
    } else {
      baseUrl = fallback;
    }
  }

  static Future<void> setBaseUrl(String url) async {
    baseUrl = url.trim().replaceAll(RegExp(r'/+$'), '');
    final p = await SharedPreferences.getInstance();
    await p.setString(_pref, baseUrl);
  }

  static Uri api(String path) {
    final root = baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    final suffix = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$root$suffix');
  }
}

abstract final class VxApiPaths {
  static const health = '/api/health';
  static const chat = '/api/chat';
  static const catalog = '/api/catalog';
  static const knowledge = '/api/knowledge';
  static const bookings = '/api/bookings';
  static const leads = '/api/leads';
  static const inbox = '/api/inbox';
  static const channels = '/api/channels';
  static const auth = '/api/auth';
  static const ragQuery = '/api/rag/query';
  static const ragIngest = '/api/rag/ingest';
  static const upload = '/api/upload';
}
