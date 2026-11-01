import 'package:flutter/material.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/search/vx_match.dart';
import 'package:vortexsales/core/state/store_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/data/mock/mock_data.dart';

class SearchHit {
  const SearchHit({
    required this.tab,
    required this.icon,
    required this.section,
    required this.title,
    required this.subtitle,
  });

  final int tab;
  final IconData icon;
  final String section;
  final String title;
  final String subtitle;
}

class SearchPanel extends StatelessWidget {
  const SearchPanel({
    super.key,
    required this.query,
    required this.onOpen,
  });

  final String query;
  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final store = StoreScope.of(context);
    final hits = _hits(t, store);
    if (hits.isEmpty) {
      return Center(
        child: Text(t.noMatches, style: const TextStyle(color: VxColors.mist400)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: hits.length,
      itemBuilder: (context, i) {
        final hit = hits[i];
        final showSection = i == 0 || hits[i - 1].section != hit.section;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showSection)
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
                child: Text(
                  hit.section.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.2,
                    color: VxColors.mist500,
                  ),
                ),
              ),
            Material(
              color: VxColors.white05,
              borderRadius: BorderRadius.circular(VxRadii.input),
              child: InkWell(
                borderRadius: BorderRadius.circular(VxRadii.input),
                onTap: () => onOpen(hit.tab),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      Icon(hit.icon, size: 18, color: VxColors.cyan),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hit.title,
                              style: const TextStyle(color: Colors.white),
                            ),
                            if (hit.subtitle.isNotEmpty)
                              Text(
                                hit.subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: VxColors.mist500,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  List<SearchHit> _hits(VxL10n t, StoreController store) {
    final out = <SearchHit>[];
    for (final c in mockConversations) {
      if (!vxMatches(query, [c.name, c.preview, c.market, c.channel])) continue;
      out.add(
        SearchHit(
          tab: 1,
          icon: Icons.chat_bubble_outline,
          section: t.inbox,
          title: c.name,
          subtitle: c.preview,
        ),
      );
    }
    for (final item in store.catalog) {
      if (!vxMatches(query, [item.sku, item.name, item.nameAr, item.stock])) {
        continue;
      }
      out.add(
        SearchHit(
          tab: 6,
          icon: Icons.inventory_2_outlined,
          section: t.catalog,
          title: t.isAr ? item.nameAr : item.name,
          subtitle: item.sku,
        ),
      );
    }
    for (final doc in store.knowledge) {
      if (!vxMatches(query, [doc.title, doc.body, doc.type])) continue;
      out.add(
        SearchHit(
          tab: 5,
          icon: Icons.menu_book_outlined,
          section: t.knowledge,
          title: doc.title,
          subtitle: doc.body,
        ),
      );
    }
    for (final b in store.bookings) {
      if (!vxMatches(query, [b.who, b.service, b.zone, b.status])) continue;
      out.add(
        SearchHit(
          tab: 3,
          icon: Icons.calendar_month_outlined,
          section: t.bookings,
          title: b.who,
          subtitle: b.service,
        ),
      );
    }
    for (final lead in store.leads) {
      if (!vxMatches(query, [lead.name, lead.email, lead.phone, lead.source])) {
        continue;
      }
      out.add(
        SearchHit(
          tab: 7,
          icon: Icons.people_outline,
          section: t.leads,
          title: lead.name,
          subtitle: lead.email,
        ),
      );
    }
    final channels = [
      t.channelWidget,
      t.whatsapp,
      t.instagram,
      t.messenger,
      t.tiktok,
      t.telegram,
    ];
    for (final name in channels) {
      if (!vxMatches(query, [name])) continue;
      out.add(
        SearchHit(
          tab: 2,
          icon: Icons.share_outlined,
          section: t.channels,
          title: name,
          subtitle: t.channelsSub,
        ),
      );
    }
    return out;
  }
}
