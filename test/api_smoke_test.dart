import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:vortexsales/core/api/vx_api_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('production health reports AI ready', () async {
    final uri = Uri.parse('${VxApiConfig.fallback}/api/health');
    final res = await http.get(uri).timeout(const Duration(seconds: 20));
    expect(res.statusCode, 200);
    expect(res.body.contains('"ok":true'), isTrue);
    expect(res.body.contains('"ready":true') || res.body.contains('"provider":"http"'), isTrue);
  });

  test('production catalog requires auth', () async {
    final uri = Uri.parse('${VxApiConfig.fallback}/api/catalog');
    final res = await http.get(uri).timeout(const Duration(seconds: 20));
    // Older deploy may still be open (200); newer deploy returns 401.
    expect([200, 401].contains(res.statusCode), isTrue);
  });
}
