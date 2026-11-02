import 'package:vortexsales/core/ai/vx_closer.dart';
import 'package:vortexsales/core/api/vx_api_client.dart';
import 'package:vortexsales/core/api/vx_api_config.dart';
import 'package:vortexsales/data/mock/mock_data.dart';

/// Talks to AMREKA2 `/api/chat`. Keys stay on the server.
class VxChatService {
  VxChatService({VxApiClient? client}) : _client = client ?? VxApiClient();

  final VxApiClient _client;

  Stream<String> reply({
    required String input,
    required List<CatalogItem> catalog,
    required List<KnowledgeItem> knowledge,
    required bool ar,
    String? instructions,
    double? tone,
    String? locale,
    String? conversationId,
    String? channel,
    List<Map<String, String>> history = const [],
  }) async* {
    if (VxApiConfig.configured) {
      try {
        yield* _client.chatTokens(
          messages: [
            ...history,
            {'role': 'user', 'content': input},
          ],
          instructions: instructions,
          tone: tone,
          locale: locale,
          conversationId: conversationId,
          channel: channel,
          catalog: catalog,
          knowledge: knowledge,
        );
        return;
      } catch (_) {
        /* live model busy or down — still close like a salesperson */
      }
    }

    final text = VxCloser(
      catalog: catalog,
      knowledge: knowledge,
      ar: ar,
    ).reply(input);
    if (VxApiConfig.configured && conversationId != null) {
      try {
        await _client.sendJson(
          VxApiPaths.inbox,
          method: 'POST',
          body: {
            'id': conversationId,
            'channel': channel ?? 'Playground',
            'name': 'Visitor',
            'messages': [
              ...history,
              {'role': 'user', 'content': input},
              {'role': 'assistant', 'content': text},
            ],
          },
        );
      } catch (_) {
        /* inbox persist is best-effort on fallback */
      }
    }
    yield text;
  }
}
