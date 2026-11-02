import 'package:vortexsales/core/api/vx_api_client.dart';
import 'package:vortexsales/core/api/vx_api_config.dart';
import 'package:vortexsales/data/mock/mock_data.dart';

class VxStoreApi {
  VxStoreApi({VxApiClient? client}) : _client = client ?? VxApiClient();

  final VxApiClient _client;

  bool get live => VxApiConfig.configured;

  Future<List<T>> _items<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final json = await _client.getJson(path);
    final raw = json['items'];
    if (raw is! List) return [];
    return [
      for (final row in raw)
        if (row is Map) fromJson(Map<String, dynamic>.from(row)),
    ];
  }

  Future<List<CatalogItem>> catalog() =>
      _items(VxApiPaths.catalog, CatalogItem.fromJson);

  Future<List<KnowledgeItem>> knowledge() =>
      _items(VxApiPaths.knowledge, KnowledgeItem.fromJson);

  Future<List<BookingItem>> bookings() =>
      _items(VxApiPaths.bookings, BookingItem.fromJson);

  Future<List<LeadItem>> leads() => _items(VxApiPaths.leads, LeadItem.fromJson);

  Future<List<Conversation>> inbox() =>
      _items(VxApiPaths.inbox, Conversation.fromJson);

  Future<void> saveCatalog(CatalogItem item) =>
      _client.sendJson(VxApiPaths.catalog, method: 'POST', body: item.toJson());

  Future<void> saveKnowledge(KnowledgeItem item) => _client.sendJson(
        VxApiPaths.knowledge,
        method: 'POST',
        body: item.toJson(),
      );

  Future<void> saveBooking(BookingItem item) =>
      _client.sendJson(VxApiPaths.bookings, method: 'POST', body: item.toJson());

  Future<void> saveLead(LeadItem item) =>
      _client.sendJson(VxApiPaths.leads, method: 'POST', body: item.toJson());

  Future<void> replyInbox(String id, String text) => _client.sendJson(
        VxApiPaths.inbox,
        method: 'POST',
        body: {'id': id, 'reply': text},
      );

  Future<void> inboxAction(String id, String action) => _client.sendJson(
        VxApiPaths.inbox,
        method: 'POST',
        body: {'id': id, 'action': action},
      );

  Future<void> saveConversation(Conversation item) => _client.sendJson(
        VxApiPaths.inbox,
        method: 'POST',
        body: item.toJson(),
      );

  Future<void> deleteCatalog(String sku) => _client.sendJson(
        '${VxApiPaths.catalog}?sku=${Uri.encodeQueryComponent(sku)}',
        method: 'DELETE',
      );

  Future<void> deleteKnowledge(String id) => _client.sendJson(
        '${VxApiPaths.knowledge}?id=${Uri.encodeQueryComponent(id)}',
        method: 'DELETE',
      );

  Future<void> deleteBooking(String id) => _client.sendJson(
        '${VxApiPaths.bookings}?id=${Uri.encodeQueryComponent(id)}',
        method: 'DELETE',
      );

  Future<void> deleteLead(String id) => _client.sendJson(
        '${VxApiPaths.leads}?id=${Uri.encodeQueryComponent(id)}',
        method: 'DELETE',
      );

  Future<Map<String, dynamic>> channels() => _client.getJson(VxApiPaths.channels);

  Future<Map<String, dynamic>> saveWhatsapp({
    required String token,
    required String phoneId,
    required String verify,
  }) =>
      _client.sendJson(
        VxApiPaths.channels,
        method: 'POST',
        body: {
          'kind': 'whatsapp',
          'token': token,
          'phoneId': phoneId,
          'verify': verify,
        },
      );

  Future<Map<String, dynamic>> testWhatsapp({
    required String to,
    String? text,
  }) =>
      _client.sendJson(
        VxApiPaths.whatsappTest,
        method: 'POST',
        body: {
          'to': to,
          if (text != null && text.trim().isNotEmpty) 'text': text.trim(),
        },
      );

  Future<void> registerDevice({required String token, String? platform}) =>
      _client.sendJson(
        VxApiPaths.devices,
        method: 'POST',
        body: {
          'token': token,
          if (platform != null) 'platform': platform,
        },
      );
}
