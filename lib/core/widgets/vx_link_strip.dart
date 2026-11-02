import 'package:flutter/material.dart';
import 'package:vortexsales/core/api/vx_api_config.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/state/app_controller.dart';
import 'package:vortexsales/core/state/store_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';

enum VxLinkKind { live, offline, session }

class VxLinkStrip extends StatelessWidget {
  const VxLinkStrip({super.key, this.onOpenServer});

  final VoidCallback? onOpenServer;

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final store = StoreScope.of(context);
    final app = VxScope.of(context);
    final kind = app.sessionExpired
        ? VxLinkKind.session
        : store.live
            ? VxLinkKind.live
            : VxLinkKind.offline;
    final label = switch (kind) {
      VxLinkKind.live => t.linkLive,
      VxLinkKind.offline => t.linkOffline,
      VxLinkKind.session => t.linkSession,
    };
    final color = switch (kind) {
      VxLinkKind.live => VxColors.cyan,
      VxLinkKind.offline => VxColors.mist400,
      VxLinkKind.session => VxColors.rose,
    };
    return Material(
      color: color.withValues(alpha: 0.12),
      child: InkWell(
        onTap: () {
          if (kind == VxLinkKind.session) {
            app.openLogin();
            return;
          }
          onOpenServer?.call();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 12, color: color),
                ),
              ),
              Text(
                kind == VxLinkKind.session
                    ? t.login
                    : (VxApiConfig.baseUrl.contains('127.0.0.1') ? 'Local' : 'API'),
                style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.9)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
