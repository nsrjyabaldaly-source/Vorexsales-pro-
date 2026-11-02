import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vortexsales/core/api/vx_api_config.dart';
import 'package:vortexsales/core/api/vx_store_api.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/search/vx_match.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/core/widgets/vx_button.dart';
import 'package:vortexsales/core/widgets/vx_field.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';
import 'package:vortexsales/core/widgets/vx_page_header.dart';
import 'package:vortexsales/features/channels/widget_preview_screen.dart';

void showChannelConnectLater(BuildContext context, String channel) {
  final t = VxL10n.of(context);
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: VxColors.ink900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VxRadii.card),
        side: const BorderSide(color: VxColors.hairline),
      ),
      title: Text(channel, style: const TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.later, style: const TextStyle(fontSize: 12, color: VxColors.cyan)),
          const SizedBox(height: 8),
          Text(
            t.laterBody,
            style: const TextStyle(fontSize: 14, height: 1.5, color: VxColors.mist300),
          ),
        ],
      ),
      actions: [
        VxButton(
          label: t.coachDone,
          size: VxButtonSize.sm,
          onPressed: () => Navigator.pop(ctx),
        ),
      ],
    ),
  );
}

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key, this.query = ''});

  final String query;

  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  final _phoneId = TextEditingController();
  final _token = TextEditingController();
  final _verify = TextEditingController();
  bool _waLive = false;
  String _snippet = '';
  String _status = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _phoneId.dispose();
    _token.dispose();
    _verify.dispose();
    super.dispose();
  }

  String _localSnippet(VxL10n t) {
    final origin = VxApiConfig.baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    return '<script src="$origin/widget.js" data-key="pk_luna_live" data-locale="${t.info.code}" async></script>';
  }

  Future<void> _load() async {
    if (!VxApiConfig.configured) return;
    try {
      final json = await VxStoreApi().channels();
      if (!mounted) return;
      setState(() {
        _waLive = json['whatsapp'] is Map && json['whatsapp']['live'] == true;
        _snippet = json['snippet'] as String? ?? '';
      });
    } catch (_) {
      /* keep local snippet */
    }
  }

  Future<void> _saveWhatsapp() async {
    final t = VxL10n.of(context);
    try {
      final json = await VxStoreApi().saveWhatsapp(
        token: _token.text,
        phoneId: _phoneId.text,
        verify: _verify.text,
      );
      if (!mounted) return;
      setState(() {
        _waLive = json['live'] == true;
        _status = _waLive ? t.connected : t.later;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final snippet = _snippet.isEmpty ? _localSnippet(t) : _snippet;
    final later = [
      (Icons.camera_alt_outlined, t.instagram),
      (Icons.chat_outlined, t.messenger),
      (Icons.music_note_outlined, t.tiktok),
      (Icons.send_outlined, t.telegram),
    ].where((ch) => vxMatches(widget.query, [ch.$2])).toList();
    final showWidget = vxMatches(widget.query, [t.channelWidget]);
    final showWa = vxMatches(widget.query, [t.whatsapp]);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        VxPageHeader(title: t.channelsTitle, subtitle: t.channelsSub),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: VxColors.cyan.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(VxRadii.input),
          ),
          child: Text(t.isolate, style: const TextStyle(fontSize: 14, color: VxColors.cyan)),
        ),
        const SizedBox(height: 12),
        if (showWidget)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: VxGlass(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _head(Icons.language, t.channelWidget, t.connected, true),
                  const SizedBox(height: 14),
                  Text(t.widgetBody, style: const TextStyle(fontSize: 14, height: 1.5, color: VxColors.mist400)),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: VxColors.ink950,
                      borderRadius: BorderRadius.circular(VxRadii.input),
                    ),
                    child: SelectableText(
                      snippet,
                      style: const TextStyle(fontSize: 12, color: VxColors.cyan),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      VxButton(
                        label: t.openWidget,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const WidgetPreviewScreen()),
                          );
                        },
                      ),
                      VxButton(
                        label: t.copySnippet,
                        variant: VxButtonVariant.secondary,
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: snippet));
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(t.snippetCopied)),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        if (showWa)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: VxGlass(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _head(Icons.phone_iphone, t.whatsapp, _waLive ? t.connected : t.later, _waLive),
                  const SizedBox(height: 14),
                  Text(t.whatsappBody, style: const TextStyle(fontSize: 14, height: 1.5, color: VxColors.mist400)),
                  const SizedBox(height: 12),
                  VxField(label: t.phoneId, child: VxTextField(controller: _phoneId)),
                  const SizedBox(height: 12),
                  VxField(label: t.accessToken, child: VxTextField(controller: _token, obscure: true)),
                  const SizedBox(height: 12),
                  VxField(label: t.verifyToken, child: VxTextField(controller: _verify)),
                  const SizedBox(height: 8),
                  Text(t.webhookHint, style: const TextStyle(fontSize: 12, color: VxColors.mist500)),
                  const SizedBox(height: 16),
                  VxButton(label: t.saveWhatsapp, onPressed: _saveWhatsapp),
                  if (_status.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(_status, style: const TextStyle(fontSize: 12, color: VxColors.cyan)),
                  ],
                ],
              ),
            ),
          ),
        for (final ch in later)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: VxGlass(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _head(ch.$1, ch.$2, t.later, false),
                  const SizedBox(height: 14),
                  Text(t.laterBody, style: const TextStyle(fontSize: 14, height: 1.5, color: VxColors.mist400)),
                  const SizedBox(height: 16),
                  VxButton(
                    label: t.connect,
                    variant: VxButtonVariant.secondary,
                    onPressed: () => showChannelConnectLater(context, ch.$2),
                  ),
                ],
              ),
            ),
          ),
        Text(t.brain, style: const TextStyle(fontSize: 14, color: VxColors.mist500)),
      ],
    );
  }

  Widget _head(IconData icon, String title, String status, bool live) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: VxColors.white08,
            borderRadius: BorderRadius.circular(VxRadii.input),
          ),
          child: Icon(icon, color: VxColors.cyan, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
            Text(
              status,
              style: TextStyle(fontSize: 12, color: live ? VxColors.cyan : VxColors.mist500),
            ),
          ],
        ),
      ],
    );
  }
}
