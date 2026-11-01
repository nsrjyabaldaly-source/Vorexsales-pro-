import 'package:flutter/material.dart';
import 'package:vortexsales/core/brand/vortex_wordmark.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/l10n/vx_locales.dart';
import 'package:vortexsales/core/state/app_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/core/widgets/vx_button.dart';
import 'package:vortexsales/core/widgets/vx_scaffold.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({
    super.key,
    this.asOverlay = false,
  });

  final bool asOverlay;

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _query = '';
  String _picked = 'en';
  bool _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_seeded) {
      _picked = VxScope.of(context).localeCode;
      _seeded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = VxScope.of(context);
    final t = app.l10n;
    final q = _query.trim().toLowerCase();
    final filtered = vxLocales.where((l) {
      if (q.isEmpty) return true;
      return l.native.toLowerCase().contains(q) ||
          l.english.toLowerCase().contains(q) ||
          l.code.toLowerCase().contains(q);
    }).toList();

    final grouped = vxGroupOrder
        .map((g) => (g, filtered.where((l) => l.group == g).toList()))
        .where((e) => e.$2.isNotEmpty)
        .toList();

    return VxScaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const VortexWordmark(),
                const Spacer(),
                if (widget.asOverlay)
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: VxColors.mist200),
                  ),
              ],
            ),
            const SizedBox(height: 32),
            Text(t.langTitle, style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 12),
            Text(
              t.langSubtitle,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: VxColors.mist300,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'اختر لغتك · Choisissez votre langue · Elige tu idioma',
              style: TextStyle(fontSize: 14, color: VxColors.mist400),
            ),
            const SizedBox(height: 24),
            TextField(
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: t.langSearch,
                prefixIcon: const Icon(Icons.search, color: VxColors.mist500),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  for (final g in grouped)
                    _group(
                      context,
                      vxGroupLabels[g.$1] ?? g.$1,
                      g.$2,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottom: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x0004060C), VxColors.ink950],
            ),
          ),
          child: VxButton(
            label: t.langContinue,
            size: VxButtonSize.lg,
            expanded: true,
            onPressed: () async {
              await app.setLocale(_picked);
              if (widget.asOverlay) {
                if (context.mounted) Navigator.pop(context);
              } else {
                await app.completeLanguage();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _group(BuildContext context, String title, List<VxLocaleInfo> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title.toUpperCase(),
            style: VxL10n.of(context).isRtl
                ? const TextStyle(fontSize: 11, color: VxColors.mist500)
                : const TextStyle(
                    fontSize: 11,
                    letterSpacing: 2.16,
                    color: VxColors.mist500,
                  ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) {
            final active = item.code == _picked;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: active ? VxColors.cyan.withValues(alpha: 0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(VxRadii.input),
                child: InkWell(
                  borderRadius: BorderRadius.circular(VxRadii.input),
                  onTap: () async {
                    setState(() => _picked = item.code);
                    await VxScope.of(context).setLocale(item.code);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(VxRadii.input),
                      border: Border.all(color: VxColors.hairline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.native,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          textDirection: item.isRtl ? TextDirection.rtl : TextDirection.ltr,
                        ),
                        Text(
                          item.english,
                          style: const TextStyle(fontSize: 11, color: VxColors.mist500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
