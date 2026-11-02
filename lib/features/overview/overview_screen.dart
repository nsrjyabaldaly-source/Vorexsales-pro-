import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:vortexsales/core/analytics/vx_week.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/search/vx_match.dart';
import 'package:vortexsales/core/state/store_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key, this.query = ''});

  final String query;

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final store = StoreScope.of(context);
    final locale = t.locale.toString();
    final fmt = intl.NumberFormat.decimalPattern(locale);
    final booked = store.bookings.where((e) => e.status == 'confirmed').length;
    final close = store.conversations.isEmpty
        ? 0
        : ((store.conversations.where((e) => e.status == 'booked').length /
                    store.conversations.length) *
                100)
            .round();
    final cards = [
      (t.conversations, fmt.format(store.conversations.length), store.live),
      (t.booked, fmt.format(booked == 0 ? store.bookings.length : booked), store.live),
      (t.newLeads, fmt.format(store.leads.length), store.live),
      (t.closeRate, '$close%', store.live),
    ];
    final week = vxWeekSeries(
      conversations: store.conversations,
      bookings: store.bookings,
      leads: store.leads,
    );
    final max = week.reduce((a, b) => a > b ? a : b).clamp(1, double.infinity);

    return RefreshIndicator(
      color: VxColors.cyan,
      backgroundColor: VxColors.ink800,
      onRefresh: store.refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
        Text(t.hello, style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 6),
        Text(t.dashSub, style: const TextStyle(fontSize: 14, color: VxColors.mist400)),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            for (final card in cards)
              VxGlass(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.$1.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: 0.8,
                        color: VxColors.mist500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      card.$2,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.storeStatus(card.$3),
                      style: const TextStyle(fontSize: 12, color: VxColors.cyan),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        VxGlass(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.week, style: const TextStyle(color: VxColors.mist300)),
              const SizedBox(height: 20),
              SizedBox(
                height: 140,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final n in week) ...[
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: (140 * (n / max)).clamp(16, 140),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                              gradient: const LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [VxColors.violet, VxColors.cyan],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        VxGlass(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.upcoming, style: const TextStyle(color: VxColors.mist300)),
              const SizedBox(height: 12),
              for (final b in store.bookings
                  .where((e) => vxMatches(query, [e.who, e.service]))
                  .take(3))
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: VxColors.white05,
                    borderRadius: BorderRadius.circular(VxRadii.input),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.who, style: const TextStyle(color: Colors.white)),
                      Text(
                        b.service,
                        style: const TextStyle(fontSize: 12, color: VxColors.mist500),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        VxGlass(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.recent, style: const TextStyle(color: VxColors.mist300)),
              const SizedBox(height: 12),
              for (final c in store.conversations
                  .where((e) => vxMatches(query, [e.name, e.preview, e.market]))
                  .take(4))
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(c.name, style: const TextStyle(color: Colors.white)),
                          const SizedBox(width: 8),
                          Text(
                            '${c.intent}%',
                            style: const TextStyle(fontSize: 12, color: VxColors.cyan),
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
            ],
          ),
        ),
        const SizedBox(height: 16),
        VxGlass(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.topSkus, style: const TextStyle(color: VxColors.mist300)),
              const SizedBox(height: 12),
              for (final item in store.catalog.where(
                (e) => vxMatches(query, [e.sku, e.name, e.nameAr]),
              ))
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          t.isAr ? item.nameAr : item.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Text(
                        item.sku,
                        style: const TextStyle(color: VxColors.mist400),
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
    );
  }
}
