import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:vortexsales/core/nav/vx_nav.dart';
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
      await _plugin.initialize(
        init,
        onDidReceiveNotificationResponse: _onTap,
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      final launch = await _plugin.getNotificationAppLaunchDetails();
      if (launch?.didNotificationLaunchApp == true) {
        _onTap(launch!.notificationResponse!);
      }
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  static void _onTap(NotificationResponse response) {
    final payload = response.payload ?? '';
    if (payload.startsWith('inbox:')) {
      final id = payload.substring(6);
      VxNav.open(
        VxNavIntent(tab: 1, conversationId: id, focusReply: true),
      );
      return;
    }
    if (payload.startsWith('booking:')) {
      VxNav.open(VxNavIntent(tab: 3, bookingId: payload.substring(8)));
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
          payload: 'inbox:${fresh.first.id}',
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
        payload: 'inbox:${needs.first.id}',
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
      final fire = when.toUtc().subtract(const Duration(hours: 1));
      if (fire.isBefore(DateTime.now().toUtc())) continue;
      await _plugin.zonedSchedule(
        nid,
        ar ? 'موعد بعد ساعة' : 'Booking in 1 hour',
        '${item.who} · ${item.service}',
        tz.TZDateTime.from(fire, tz.UTC),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'booking:${item.id}',
      );
    }
  }
}
