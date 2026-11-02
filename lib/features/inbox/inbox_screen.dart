import 'package:flutter/material.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/search/vx_match.dart';
import 'package:vortexsales/core/state/store_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/core/widgets/vx_button.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';
import 'package:vortexsales/data/mock/mock_data.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key, this.query = ''});

  final String query;

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  String? _openId;

  String _statusLabel(VxL10n t, String status) => switch (status) {
        'booked' => t.bookedStatus,
        'needs_you' => t.needsYou,
        _ => t.openStatus,
      };

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final store = StoreScope.of(context);
    final rows = store.conversations
        .where(
          (c) => vxMatches(widget.query, [c.name, c.preview, c.market, c.channel]),
        )
        .toList();
    final current = _openId == null
        ? null
        : store.conversations.where((c) => c.id == _openId).firstOrNull;

    if (current != null) {
      return _Thread(
        conversation: current,
        statusLabel: _statusLabel(t, current.status),
        onBack: () => setState(() => _openId = null),
        onReply: (text) => store.replyInbox(current.id, text),
        onAction: (action) => store.inboxAction(current.id, action),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(t.inboxTitle, style: Theme.of(context).textTheme.displaySmall),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            t.storeStatus(store.live),
            style: const TextStyle(fontSize: 12, color: VxColors.mist500),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: VxColors.cyan,
            backgroundColor: VxColors.ink800,
            onRefresh: store.refresh,
            child: rows.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 120),
                      Center(
                        child: Text(
                          t.noMatches,
                          style: const TextStyle(color: VxColors.mist500),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: rows.length,
                    itemBuilder: (context, i) {
                      final c = rows[i];
                      return InkWell(
                        onTap: () => setState(() => _openId = c.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: VxColors.hairline)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(c.name, style: const TextStyle(color: Colors.white)),
                                  ),
                                  Text(
                                    c.status == 'needs_you' ? t.needsYou : c.time,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: c.status == 'needs_you' ? VxColors.cyan : VxColors.mist500,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                c.preview,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, color: VxColors.mist500),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

class _Thread extends StatefulWidget {
  const _Thread({
    required this.conversation,
    required this.statusLabel,
    required this.onBack,
    required this.onReply,
    required this.onAction,
  });

  final Conversation conversation;
  final String statusLabel;
  final VoidCallback onBack;
  final Future<void> Function(String text) onReply;
  final Future<void> Function(String action) onAction;

  @override
  State<_Thread> createState() => _ThreadState();
}

class _ThreadState extends State<_Thread> {
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    _input.clear();
    await widget.onReply(text);
  }

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final conversation = widget.conversation;
    final lines = conversation.messages.isNotEmpty
        ? conversation.messages
        : [ChatLine(id: 'p', role: 'user', content: conversation.preview)];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
          child: Row(
            children: [
              IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back, color: VxColors.mist200),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(conversation.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                    Text(
                      '${conversation.market} · ${conversation.channel} · ${widget.statusLabel}${conversation.handedOff ? ' · ${t.inboxHandedOff}' : ''}',
                      style: const TextStyle(fontSize: 12, color: VxColors.mist500),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: VxColors.cyan.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(VxRadii.pill),
                ),
                child: Text(
                  '${conversation.intent}% ${t.intent}',
                  style: const TextStyle(fontSize: 12, color: VxColors.cyan),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: VxColors.hairline),
        if (conversation.handedOff || (conversation.bookingId ?? '').isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (conversation.handedOff)
                  VxButton(
                    label: t.inboxResume,
                    size: VxButtonSize.sm,
                    onPressed: () => widget.onAction('resume'),
                  ),
                if ((conversation.bookingId ?? '').isNotEmpty) ...[
                  VxButton(
                    label: t.inboxConfirm,
                    size: VxButtonSize.sm,
                    onPressed: () => widget.onAction('confirm'),
                  ),
                  VxButton(
                    label: t.inboxCancel,
                    size: VxButtonSize.sm,
                    onPressed: () => widget.onAction('cancel'),
                  ),
                ],
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lines.length,
            itemBuilder: (context, i) {
              final m = lines[i];
              final mine = m.role == 'assistant' || m.role == 'merchant';
              return Align(
                alignment: mine
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: mine
                        ? DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(VxRadii.input),
                              gradient: const LinearGradient(colors: VxColors.brandGradient),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (m.role == 'merchant')
                                    Text(
                                      t.inboxTeam,
                                      style: const TextStyle(fontSize: 10, color: VxColors.ink950),
                                    ),
                                  Text(
                                    m.content,
                                    style: const TextStyle(color: VxColors.ink950, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : VxHairline(
                            radius: VxRadii.input,
                            color: VxColors.white08,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Text(
                              m.content,
                              style: const TextStyle(color: VxColors.mist100, fontSize: 14),
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1, color: VxColors.hairline),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
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
                      hintText: t.inboxReply,
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
    );
  }
}
