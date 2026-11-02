import 'package:flutter/material.dart';
import 'package:vortexsales/core/api/vx_chat_service.dart';
import 'package:vortexsales/core/brand/vortex_mark.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/state/app_controller.dart';
import 'package:vortexsales/core/state/store_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/core/widgets/vx_aurora.dart';
import 'package:vortexsales/core/widgets/vx_button.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';

class _Msg {
  _Msg(this.role, this.content);
  final String role;
  String content;
}

class WidgetPreviewScreen extends StatefulWidget {
  const WidgetPreviewScreen({super.key});

  @override
  State<WidgetPreviewScreen> createState() => _WidgetPreviewScreenState();
}

class _WidgetPreviewScreenState extends State<WidgetPreviewScreen> {
  final _input = TextEditingController();
  late List<_Msg> _messages;
  bool _ready = false;
  bool _previewAr = false;
  final _threadId =
      'c_${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ready) return;
    final app = VxScope.of(context);
    _previewAr = app.localeCode.startsWith('ar');
    _messages = [_Msg('assistant', VxL10n.of(context).widgetHello)];
    _ready = true;
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _toggleLocale() async {
    final next = !_previewAr;
    setState(() {
      _previewAr = next;
      _messages = [
        _Msg(
          'assistant',
          next
              ? 'أهلاً، معك مساعد المتجر. تبي أحجز لك ولا أساعدك تختار؟'
              : 'Hi — I am the shop assistant. What can I book or find for you?',
        ),
      ];
    });
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    final store = StoreScope.of(context);
    setState(() {
      _messages.add(_Msg('user', text));
      _input.clear();
      _messages.add(_Msg('assistant', ''));
    });
    await for (final chunk in VxChatService().reply(
      input: text,
      catalog: store.catalog,
      knowledge: store.knowledge,
      ar: _previewAr,
      locale: _previewAr ? 'ar' : 'en',
      conversationId: _threadId,
      channel: 'Widget',
      history: [
        for (final m in _messages.take(_messages.length - 2).where((m) => m.content.isNotEmpty))
          {'role': m.role, 'content': m.content},
      ],
    )) {
      if (!mounted) return;
      setState(() => _messages.last.content += chunk);
    }
    if (mounted) await store.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    return Scaffold(
      backgroundColor: VxColors.ink900,
      body: VxAurora(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: VxColors.mist200),
                    ),
                    Text(
                      t.previewKicker.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        letterSpacing: 2,
                        color: VxColors.cyan,
                      ),
                    ),
                    const Spacer(),
                    VxButton(
                      label: t.previewLocale,
                      size: VxButtonSize.sm,
                      variant: VxButtonVariant.ghost,
                      onPressed: _toggleLocale,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(t.previewTitle, style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 8),
                Text(t.previewBody, style: const TextStyle(fontSize: 14, color: VxColors.mist400)),
                const SizedBox(height: 16),
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 340),
                        decoration: BoxDecoration(
                          color: VxColors.ink950,
                          borderRadius: BorderRadius.circular(36),
                          border: Border.all(color: VxColors.mist500.withValues(alpha: 0.35), width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: VxColors.cyan.withValues(alpha: 0.12),
                              blurRadius: 28,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(10, 14, 10, 10),
                        child: Column(
                          children: [
                            Container(
                              width: 96,
                              height: 8,
                              decoration: BoxDecoration(
                                color: VxColors.ink800,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Directionality(
                                textDirection:
                                    _previewAr ? TextDirection.rtl : TextDirection.ltr,
                                child: VxGlass(
                                  radius: 22,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            const VortexMark.chat(),
                                            const SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  t.previewTitle,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                Text(
                                                  t.widgetOnline,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: VxColors.cyan,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(height: 1, color: VxColors.hairline),
                                      Expanded(
                                        child: ListView.builder(
                                          padding: const EdgeInsets.all(12),
                                          itemCount: _messages.length,
                                          itemBuilder: (context, i) {
                                            final m = _messages[i];
                                            final user = m.role == 'user';
                                            return Align(
                                              alignment: user
                                                  ? AlignmentDirectional.centerEnd
                                                  : AlignmentDirectional.centerStart,
                                              child: Container(
                                                margin: const EdgeInsets.only(bottom: 8),
                                                constraints: const BoxConstraints(maxWidth: 220),
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(VxRadii.input),
                                                  color: user ? null : VxColors.white08,
                                                  gradient: user
                                                      ? const LinearGradient(
                                                          colors: VxColors.brandGradient,
                                                        )
                                                      : null,
                                                ),
                                                child: Text(
                                                  m.content.isEmpty ? '…' : m.content,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    height: 1.4,
                                                    color: user
                                                        ? VxColors.ink950
                                                        : VxColors.mist100,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                height: 40,
                                                child: TextField(
                                                  controller: _input,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                  ),
                                                  onSubmitted: (_) => _send(),
                                                  decoration: InputDecoration(
                                                    hintText: t.widgetPlaceholder,
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(
                                                        VxRadii.pill,
                                                      ),
                                                      borderSide: const BorderSide(
                                                        color: VxColors.hairline,
                                                      ),
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(
                                                        VxRadii.pill,
                                                      ),
                                                      borderSide: const BorderSide(
                                                        color: VxColors.hairline,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            VxButton(
                                              label: t.send,
                                              size: VxButtonSize.sm,
                                              onPressed: _send,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
