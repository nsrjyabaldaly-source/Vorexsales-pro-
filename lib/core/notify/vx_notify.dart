import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/data/mock/mock_data.dart';

abstract final class VxNotify {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static var _ready = false;

  static const _android = AndroidNotificationDetails(
    'vortex_inbox',
    'VortexSales',
    channelDescription: 'Inbox and booking alerts',
    importance: Importance.high,
    priority: Priority.high,
    color: VxColors.cyan,
  );

  static Future<void> init() async {
    try {
      tzdata.initializeTimeZones();
      const init = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      );
      await _plugin.initialize(init);
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  static Future<void> sync({
    required List<Conversation> conversations,
    required List<BookingItem> bookings,
    required bool ar,
  }) async {
    if (!_ready) return;
    const details = NotificationDetails(
      android: _android,
      iOS: DarwinNotificationDetails(),
    );
    final p = await SharedPreferences.getInstance();
    final needs = conversations.where((c) => c.status == 'needs_you').toList();
    final seen = p.getStringList('vx.notify.inbox') ?? [];
    final primed = p.getBool('vx.notify.ready') ?? false;
    if (!primed) {
      await p.setStringList(
        'vx.notify.inbox',
        [for (final row in needs) row.id],
      );
      await p.setBool('vx.notify.ready', true);
    } else {
      final fresh = needs.where((row) => !seen.contains(row.id)).toList();
      if (fresh.isNotEmpty) {
        await _plugin.show(
          1,
          ar ? 'تحتاجك في الصندوق' : 'Inbox needs you',
          fresh.first.preview,
          details,
        );
      }
      await p.setStringList(
        'vx.notify.inbox',
        [for (final row in needs) row.id],
      );
    }

    if (needs.isNotEmpty) {
      await _plugin.periodicallyShowWithDuration(
        100,
        ar ? 'صندوق VortexSales' : 'VortexSales inbox',
        ar
            ? '${needs.length} محادثة تحتاجك'
            : '${needs.length} conversation${needs.length == 1 ? '' : 's'} need you',
        const Duration(minutes: 15),
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } else {
      await _plugin.cancel(100);
    }

    for (final item in bookings) {
      final nid = item.id.hashCode & 0x7fffffff;
      if (item.status == 'cancelled') {
        await _plugin.cancel(nid);
        continue;
      }
      final when = DateTime.tryParse(item.when);
      if (when == null) continue;
      final fire = when.toUtc().subtract(const Duration(minutes: 30));
      if (fire.isBefore(DateTime.now().toUtc())) continue;
      await _plugin.zonedSchedule(
        nid,
        ar ? 'موعد بعد نصف ساعة' : 'Booking in 30 minutes',
        '${item.who} · ${item.service}',
        tz.TZDateTime.from(fire, tz.UTC),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }
}
