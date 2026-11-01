import 'package:flutter/material.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/search/vx_match.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
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

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final rows = mockConversations
        .where(
          (c) => vxMatches(widget.query, [c.name, c.preview, c.market, c.channel]),
        )
        .toList();
    final current = _openId == null
        ? null
        : mockConversations.where((c) => c.id == _openId).firstOrNull;

    if (current != null) {
      return _Thread(conversation: current, onBack: () => setState(() => _openId = null));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(t.inboxTitle, style: Theme.of(context).textTheme.displaySmall),
        ),
        Expanded(
          child: rows.isEmpty
              ? Center(
                  child: Text(
                    t.noMatches,
                    style: const TextStyle(color: VxColors.mist500),
                  ),
                )
              : ListView.builder(
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
                            c.time,
                            style: const TextStyle(fontSize: 11, color: VxColors.mist500),
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
      ],
    );
  }
}

class _Thread extends StatelessWidget {
  const _Thread({required this.conversation, required this.onBack});

  final Conversation conversation;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, color: VxColors.mist200),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(conversation.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                    Text(
                      '${conversation.market} · ${conversation.channel}',
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
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: VxHairline(
                    radius: VxRadii.input,
                    color: VxColors.white08,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      conversation.preview,
                      style: const TextStyle(color: VxColors.mist100, fontSize: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(VxRadii.input),
                      gradient: const LinearGradient(colors: VxColors.brandGradient),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        t.replyLocked,
                        style: const TextStyle(color: VxColors.ink950, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
