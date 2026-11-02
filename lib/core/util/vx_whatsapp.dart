import 'package:url_launcher/url_launcher.dart';

Future<bool> vxOpenWhatsApp(String? phone, {String? text}) async {
  final digits = (phone ?? '').replaceAll(RegExp(r'[^\d+]'), '');
  if (digits.isEmpty) return false;
  final cleaned = digits.startsWith('+') ? digits.substring(1) : digits;
  final uri = Uri.parse(
    text == null || text.isEmpty
        ? 'https://wa.me/$cleaned'
        : 'https://wa.me/$cleaned?text=${Uri.encodeComponent(text)}',
  );
  if (!await canLaunchUrl(uri)) return false;
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
