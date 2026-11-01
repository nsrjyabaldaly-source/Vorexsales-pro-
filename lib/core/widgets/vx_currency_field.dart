import 'package:flutter/material.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';
import 'package:vortexsales/core/widgets/vx_pills.dart';
import 'package:vortexsales/data/currencies/vx_currencies.dart';

class VxCurrencyField extends StatelessWidget {
  const VxCurrencyField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final current = vxCurrencyByCode(value.isEmpty ? 'USD' : value);
    return Material(
      color: VxColors.white05,
      borderRadius: BorderRadius.circular(VxRadii.input),
      child: InkWell(
        borderRadius: BorderRadius.circular(VxRadii.input),
        onTap: () => _open(context),
        child: SizedBox(
          height: 44,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  current.symbol,
                  style: const TextStyle(color: VxColors.cyan, fontSize: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${current.code} · ${current.name(t.isAr)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                const Icon(Icons.expand_more, color: VxColors.mist400, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CurrencySheet(selected: value.isEmpty ? 'USD' : value),
    );
    if (picked != null) onChanged(picked);
  }
}

class _CurrencySheet extends StatefulWidget {
  const _CurrencySheet({required this.selected});

  final String selected;

  @override
  State<_CurrencySheet> createState() => _CurrencySheetState();
}

class _CurrencySheetState extends State<_CurrencySheet> {
  String _query = '';
  String? _marketId;

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final ar = t.isAr;
    final height = MediaQuery.sizeOf(context).height * 0.82;
    final q = _query.trim();
    final marketHits = q.isEmpty
        ? vxDualMarkets
        : vxDualMarkets.where((m) => m.matches(q)).toList();
    VxCurrencyMarket? activeMarket;
    if (_marketId != null) {
      for (final m in vxDualMarkets) {
        if (m.id == _marketId) {
          activeMarket = m;
          break;
        }
      }
    }

    Iterable<VxCurrency> pool = vxCurrencies;
    if (activeMarket != null) {
      pool = [for (final code in activeMarket.codes) vxCurrencyByCode(code)];
    } else if (q.isNotEmpty) {
      final fromMarkets = <String>{
        for (final m in marketHits) ...m.codes,
      };
      pool = vxCurrencies.where((c) => c.matches(q) || fromMarkets.contains(c.code));
    }
    final rows = activeMarket != null
        ? pool.toList()
        : vxCurrenciesUsdFirst(pool);
    final common = vxCurrenciesUsdFirst(
      vxCurrencies.where((c) => vxCommonCurrencyCodes.contains(c.code)),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: height,
        child: VxGlass(
          radius: 28,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(t.currency, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              TextField(
                autofocus: true,
                onChanged: (v) => setState(() {
                  _query = v;
                  _marketId = null;
                }),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: t.currencySearch,
                  prefixIcon: const Icon(Icons.search, color: VxColors.mist500),
                ),
              ),
              if (q.isEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  t.dualMarkets,
                  style: const TextStyle(fontSize: 11, letterSpacing: 1, color: VxColors.mist500),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final m in vxDualMarkets)
                      VxPill(
                        label: m.name(ar),
                        selected: _marketId == m.id,
                        onTap: () => setState(() {
                          _marketId = _marketId == m.id ? null : m.id;
                        }),
                      ),
                  ],
                ),
              ] else if (marketHits.isNotEmpty && activeMarket == null) ...[
                const SizedBox(height: 12),
                for (final m in marketHits)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '${m.name(ar)} · ${m.codes.join(' · ')}',
                      style: const TextStyle(fontSize: 12, color: VxColors.cyan),
                    ),
                  ),
              ],
              const SizedBox(height: 12),
              Text(
                activeMarket != null
                    ? activeMarket.name(ar)
                    : q.isEmpty
                        ? t.commonCurrencies
                        : t.allCurrencies,
                style: const TextStyle(fontSize: 11, letterSpacing: 1, color: VxColors.mist500),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: rows.isEmpty
                    ? Center(
                        child: Text(
                          t.noMatches,
                          style: const TextStyle(color: VxColors.mist400),
                        ),
                      )
                    : ListView(
                        children: [
                          if (q.isEmpty && activeMarket == null) ...[
                            for (final c in common) _tile(context, c, t),
                            const SizedBox(height: 12),
                            Text(
                              t.allCurrencies,
                              style: const TextStyle(
                                fontSize: 11,
                                letterSpacing: 1,
                                color: VxColors.mist500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            for (final c in rows.where(
                              (c) => !vxCommonCurrencyCodes.contains(c.code),
                            ))
                              _tile(context, c, t),
                          ] else
                            for (final c in rows) _tile(context, c, t),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, VxCurrency c, VxL10n t) {
    final selected = c.code == widget.selected;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: selected ? VxColors.cyan.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(VxRadii.input),
        child: InkWell(
          borderRadius: BorderRadius.circular(VxRadii.input),
          onTap: () => Navigator.pop(context, c.code),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(VxRadii.input),
              border: Border.all(color: VxColors.hairline),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Text(
                    c.symbol,
                    style: const TextStyle(color: VxColors.cyan, fontSize: 16),
                    textDirection: TextDirection.ltr,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.code,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                      Text(
                        c.name(t.isAr),
                        style: const TextStyle(fontSize: 12, color: VxColors.mist500),
                      ),
                    ],
                  ),
                ),
                if (selected)
                  const Icon(Icons.check, size: 18, color: VxColors.cyan),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
