import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vortexsales/core/api/vx_api_config.dart';
import 'package:vortexsales/core/api/vx_session.dart';
import 'package:vortexsales/data/mock/mock_data.dart';

class VxApiException implements Exception {
  VxApiException(this.message, {this.status});

  final String message;
  final int? status;

  @override
  String toString() => message;
}

class VxHealth {
  const VxHealth({
    required this.ok,
    required this.mode,
    required this.serverUrl,
    required this.database,
    required this.aiProvider,
    required this.aiReady,
  });

  final bool ok;
  final String mode;
  final bool serverUrl;
  final bool database;
  final String aiProvider;
  final bool aiReady;

  factory VxHealth.fromJson(Map<String, dynamic> json) {
    final ai = json['ai'];
    return VxHealth(
      ok: json['ok'] == true,
      mode: json['mode'] as String? ?? 'memory',
      serverUrl: json['serverUrl'] == true,
      database: json['database'] == true,
      aiProvider: ai is Map ? (ai['provider'] as String? ?? 'mock') : 'mock',
      aiReady: ai is Map && ai['ready'] == true,
    );
  }
}

/// Flutter HTTP client for AMREKA2 `/api/*`. No secrets in the app.
class VxApiClient {
  VxApiClient({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  final http.Client _http;
  static const _timeout = Duration(seconds: 20);

  Future<VxHealth> health() async {
    final json = await getJson(VxApiPaths.health);
    return VxHealth.fromJson(json);
  }

  Future<Map<String, dynamic>> getJson(String path) async {
    _ensureConfigured();
    final res = await _http
        .get(VxApiConfig.api(path), headers: VxSession.headers())
        .timeout(_timeout);
    return _decode(res);
  }

  Future<Map<String, dynamic>> sendJson(
    String path, {
    required String method,
    Map<String, dynamic>? body,
  }) async {
    _ensureConfigured();
    final uri = VxApiConfig.api(path);
    final encoded = body == null ? null : jsonEncode(body);
    final headers = VxSession.headers();
    final res = switch (method.toUpperCase()) {
      'POST' => await _http.post(uri, headers: headers, body: encoded),
      'PUT' => await _http.put(uri, headers: headers, body: encoded),
      'DELETE' => await _http.delete(uri, headers: headers, body: encoded),
      _ => throw VxApiException('Unsupported method $method'),
    };
    return _decode(res);
  }

  Stream<String> chatTokens({
    required List<Map<String, String>> messages,
    String? instructions,
    double? tone,
    String? locale,
    String? conversationId,
    String? channel,
    List<CatalogItem>? catalog,
    List<KnowledgeItem>? knowledge,
  }) async* {
    _ensureConfigured();
    final req = http.Request('POST', VxApiConfig.api(VxApiPaths.chat))
      ..headers.addAll({
        ...VxSession.headers(extra: {'Accept': 'text/event-stream'}),
      })
      ..body = jsonEncode({
        'messages': messages,
        'instructions': ?instructions,
        'tone': ?tone,
        'locale': ?locale,
        'conversationId': ?conversationId,
        'channel': ?channel,
        'grounding': {
          'catalog': [
            for (final item in catalog ?? const <CatalogItem>[]) item.toJson(),
          ],
          'knowledge': [
            for (final doc in knowledge ?? const <KnowledgeItem>[]) doc.toJson(),
          ],
        },
      });
    final res = await _http.send(req).timeout(_timeout);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw VxApiException('chat failed', status: res.statusCode);
    }
    yield* _sseTokens(res.stream);
  }

  Stream<String> _sseTokens(Stream<List<int>> bytes) async* {
    final lines = bytes.transform(utf8.decoder).transform(const LineSplitter());
    await for (final line in lines) {
      if (!line.startsWith('data:')) continue;
      final data = line.substring(5).trim();
      if (data.isEmpty || data == '[DONE]') continue;
      final decoded = json.decode(data);
      if (decoded is Map && decoded['error'] is String) {
        throw VxApiException(decoded['error'] as String);
      }
      if (decoded is Map && decoded['token'] is String) {
        yield decoded['token'] as String;
      }
    }
  }

  /// Multipart upload for knowledge files. Keys stay on the server.
  Future<Map<String, dynamic>> uploadFile({
    required List<int> bytes,
    required String filename,
    String? caption,
  }) async {
    _ensureConfigured();
    final req = http.MultipartRequest(
      'POST',
      VxApiConfig.api(VxApiPaths.upload),
    );
    req.headers.addAll({
      if (VxSession.token.isNotEmpty)
        'Authorization': 'Bearer ${VxSession.token}',
    });
    req.files.add(
      http.MultipartFile.fromBytes('file', bytes, filename: filename),
    );
    if (caption != null && caption.trim().isNotEmpty) {
      req.fields['caption'] = caption.trim();
    }
    final streamed = await _http.send(req).timeout(_timeout);
    final res = await http.Response.fromStream(streamed);
    return _decode(res);
  }

  void _ensureConfigured() {
    if (!VxApiConfig.configured) {
      throw VxApiException(
        'Set the AMREKA2 origin in Settings → Server. No API keys belong in this app.',
      );
    }
  }

  Map<String, dynamic> _decode(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      try {
        final decoded = json.decode(res.body);
        if (decoded is Map && decoded['error'] is String) {
          throw VxApiException(decoded['error'] as String, status: res.statusCode);
        }
      } catch (e) {
        if (e is VxApiException) rethrow;
      }
      throw VxApiException(res.body, status: res.statusCode);
    }
    if (res.body.isEmpty) return {};
    final decoded = json.decode(res.body);
    return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
  }

}
