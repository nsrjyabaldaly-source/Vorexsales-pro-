import 'package:flutter/material.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/search/vx_match.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/core/widgets/vx_button.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';
import 'package:vortexsales/core/widgets/vx_page_header.dart';
import 'package:vortexsales/features/channels/widget_preview_screen.dart';

class ChannelsScreen extends StatelessWidget {
  const ChannelsScreen({super.key, this.query = ''});

  final String query;

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final channels = [
      (Icons.language, t.channelWidget, true),
      (Icons.phone_iphone, t.whatsapp, false),
      (Icons.camera_alt_outlined, t.instagram, false),
      (Icons.chat_outlined, t.messenger, false),
      (Icons.music_note_outlined, t.tiktok, false),
      (Icons.send_outlined, t.telegram, false),
    ].where((ch) => vxMatches(query, [ch.$2])).toList();

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
        for (final ch in channels)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: VxGlass(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: VxColors.white08,
                          borderRadius: BorderRadius.circular(VxRadii.input),
                        ),
                        child: Icon(ch.$1, color: VxColors.cyan, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ch.$2, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                          Text(
                            ch.$3 ? t.connected : t.later,
                            style: TextStyle(
                              fontSize: 12,
                              color: ch.$3 ? VxColors.cyan : VxColors.mist500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    ch.$3 ? t.widgetBody : t.laterBody,
                    style: const TextStyle(fontSize: 14, height: 1.5, color: VxColors.mist400),
                  ),
                  const SizedBox(height: 16),
                  if (ch.$3)
                    VxButton(
                      label: t.openWidget,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const WidgetPreviewScreen()),
                        );
                      },
                    )
                  else
                    VxButton(
                      label: t.connect,
                      variant: VxButtonVariant.secondary,
                      onPressed: null,
                    ),
                ],
              ),
            ),
          ),
        Text(t.brain, style: const TextStyle(fontSize: 14, color: VxColors.mist500)),
      ],
    );
  }
}
