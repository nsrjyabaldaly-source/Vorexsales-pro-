import 'package:flutter/material.dart';
import 'package:vortexsales/core/api/vx_chat_service.dart';
import 'package:vortexsales/core/brand/vortex_mark.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/state/store_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/core/widgets/vx_button.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';
import 'package:vortexsales/core/widgets/vx_page_header.dart';

class _Msg {
  _Msg(this.role, this.content);
  final String role;
  String content;
}

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  double _tone = 60;
  late TextEditingController _instructions;
  final _input = TextEditingController();
  late List<_Msg> _messages;
  bool _ready = false;
  final _threadId =
      'c_${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ready) return;
    final t = VxL10n.of(context);
    _instructions = TextEditingController(text: t.mockInstructions);
    _messages = [_Msg('assistant', t.mockHello)];
    _ready = true;
  }

  @override
  void dispose() {
    _instructions.dispose();
    _input.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    final t = VxL10n.of(context);
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
      ar: t.isAr,
      instructions: _instructions.text,
      tone: _tone,
      locale: t.info.code,
      conversationId: _threadId,
      channel: 'Playground',
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
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        VxPageHeader(title: t.playgroundTitle, subtitle: t.playgroundSub),
        const SizedBox(height: 16),
        VxGlass(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(t.tone.toUpperCase(), style: const TextStyle(fontSize: 11, color: VxColors.mist500)),
              Slider(value: _tone, min: 0, max: 100, onChanged: (v) => setState(() => _tone = v)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t.warm, style: const TextStyle(fontSize: 11, color: VxColors.mist500)),
                  Text(t.precise, style: const TextStyle(fontSize: 11, color: VxColors.mist500)),
                  Text(t.boldCloser, style: const TextStyle(fontSize: 11, color: VxColors.mist500)),
                ],
              ),
              const SizedBox(height: 16),
              Text(t.language.toUpperCase(), style: const TextStyle(fontSize: 11, color: VxColors.mist500)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: VxColors.white05,
                  borderRadius: BorderRadius.circular(VxRadii.input),
                ),
                child: Text(t.localeChip, style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
              Text(t.instructions.toUpperCase(), style: const TextStyle(fontSize: 11, color: VxColors.mist500)),
              const SizedBox(height: 8),
              VxTextArea(controller: _instructions),
            ],
          ),
        ),
        const SizedBox(height: 16),
        VxGlass(
          child: SizedBox(
            height: 420,
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
                          const Text('Luna Dental', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                          Text(
                            'MockProvider · server-first',
                            style: const TextStyle(fontSize: 11, color: VxColors.cyan),
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
                          constraints: const BoxConstraints(maxWidth: 280),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(VxRadii.input),
                            color: user ? null : VxColors.white08,
                            gradient: user
                                ? const LinearGradient(colors: VxColors.brandGradient)
                                : null,
                          ),
                          child: Text(
                            m.content.isEmpty ? '…' : m.content,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: user ? VxColors.ink950 : VxColors.mist100,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1, color: VxColors.hairline),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: TextField(
                            controller: _input,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            onSubmitted: (_) => _send(),
                            decoration: InputDecoration(
                              hintText: t.askPlaceholder,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(VxRadii.pill),
                                borderSide: const BorderSide(color: VxColors.hairline),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(VxRadii.pill),
                                borderSide: const BorderSide(color: VxColors.hairline),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      VxButton(label: t.send, onPressed: _send),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class VxTextArea extends StatelessWidget {
  const VxTextArea({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 5,
      style: const TextStyle(color: VxColors.mist100, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: VxColors.white05,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VxRadii.input),
          borderSide: const BorderSide(color: VxColors.hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(VxRadii.input),
          borderSide: const BorderSide(color: VxColors.hairline),
        ),
      ),
    );
  }
}
