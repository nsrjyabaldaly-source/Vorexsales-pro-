import 'package:flutter/foundation.dart';

/// Lightweight in-app deep links (notifications, search, shortcuts).
class VxNavIntent {
  const VxNavIntent({
    required this.tab,
    this.conversationId,
    this.focusReply = false,
    this.bookingId,
    this.leadId,
    this.sku,
  });

  final int tab;
  final String? conversationId;
  final bool focusReply;
  final String? bookingId;
  final String? leadId;
  final String? sku;
}

abstract final class VxNav {
  static final ValueNotifier<VxNavIntent?> pending = ValueNotifier(null);

  static void open(VxNavIntent intent) => pending.value = intent;

  static VxNavIntent? take() {
    final value = pending.value;
    pending.value = null;
    return value;
  }
}
