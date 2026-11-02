import 'package:flutter/material.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/state/app_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/core/widgets/vx_button.dart';
import 'package:vortexsales/core/widgets/vx_field.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';
import 'package:vortexsales/core/widgets/vx_pills.dart';
import 'package:vortexsales/data/mock/mock_data.dart';
import 'package:vortexsales/features/channels/channels_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    this.onOpenChannels,
    this.initialTab = 'agent',
  });

  /// Opens the Channels tab in the shell. Falls back to a pushed page.
  final VoidCallback? onOpenChannels;
  final String initialTab;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _tab;

  @override
  void initState() {
    super.initState();
    _tab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final tabs = [
      ('agent', t.agent),
      ('widget', t.widget),
      ('channels', t.channels),
      ('server', t.server),
      ('team', t.team),
      ('billing', t.billing),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(t.settingsTitle, style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tab in tabs)
              VxPill(
                label: tab.$2,
                selected: _tab == tab.$1,
                onTap: () => setState(() => _tab = tab.$1),
              ),
          ],
        ),
        const SizedBox(height: 16),
        VxGlass(
          padding: const EdgeInsets.all(20),
          child: _body(context, t),
        ),
      ],
    );
  }

  void _openChannels(BuildContext context) {
    final open = widget.onOpenChannels;
    if (open != null) {
      open();
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const _ChannelsPage()),
    );
  }

  Widget _body(BuildContext context, VxL10n t) {
    switch (_tab) {
      case 'widget':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.embed, style: const TextStyle(color: VxColors.mist300)),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: VxColors.ink950,
                borderRadius: BorderRadius.circular(VxRadii.input),
              ),
              child: const SelectableText(
                '<script src="https://vortexsales.app/embed.js" data-key="pk_luna_live"></script>',
                style: TextStyle(fontSize: 12, color: VxColors.cyan),
              ),
            ),
          ],
        );
      case 'channels':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.channelsSub, style: const TextStyle(color: VxColors.mist300)),
            const SizedBox(height: 16),
            VxButton(
              label: t.channelsTitle,
              onPressed: () => _openChannels(context),
            ),
          ],
        );
      case 'server':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.serverNote, style: const TextStyle(fontSize: 14, color: VxColors.mist400)),
            const SizedBox(height: 16),
            VxField(label: t.serverUrl, child: VxTextField(hint: t.emptyPlaceholder)),
            const SizedBox(height: 12),
            VxField(label: t.database, child: VxTextField(hint: t.emptyPlaceholder)),
            const SizedBox(height: 12),
            VxField(label: t.aiKey, child: VxTextField(hint: t.emptyPlaceholder)),
          ],
        );
      case 'team':
        return Column(
          children: [
            for (final m in mockTeam)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: VxColors.white05,
                  borderRadius: BorderRadius.circular(VxRadii.input),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(m.name, style: const TextStyle(color: Colors.white))),
                    Text(
                      '${m.role} · ${m.loc}',
                      style: const TextStyle(fontSize: 12, color: VxColors.mist500),
                    ),
                  ],
                ),
              ),
          ],
        );
      case 'billing':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.planName, style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 8),
            Text(t.planBlurb, style: const TextStyle(color: VxColors.mist400)),
            const SizedBox(height: 8),
            Text(t.billingNote, style: const TextStyle(fontSize: 12, color: VxColors.mist500)),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VxButton(
              label: t.replay,
              variant: VxButtonVariant.secondary,
              onPressed: () => VxScope.of(context).replayHowTo(),
            ),
            const SizedBox(height: 16),
            VxField(
              label: t.publicName,
              child: const VxTextField(initialValue: 'Luna Dental closer'),
            ),
            const SizedBox(height: 12),
            VxField(
              label: t.market,
              child: const VxTextField(initialValue: 'Dubai · Asia/Dubai · AR + EN'),
            ),
          ],
        );
    }
  }
}

class _ChannelsPage extends StatelessWidget {
  const _ChannelsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VxColors.ink900,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: VxColors.mist200),
              ),
            ),
          ),
          const Expanded(child: ChannelsScreen()),
        ],
      ),
    );
  }
}
