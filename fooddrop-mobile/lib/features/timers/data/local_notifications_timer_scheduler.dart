import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'timer_notification_scheduler.dart';

const _androidIcon = 'ic_stat_timer';

const _details = NotificationDetails(
  android: AndroidNotificationDetails(
    'timers',
    'Hẹn giờ nấu ăn',
    channelDescription: 'Báo khi một bộ đếm giờ nấu ăn kết thúc',
    importance: Importance.max,
    priority: Priority.high,
    category: AndroidNotificationCategory.alarm,
    icon: _androidIcon,
  ),
  iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true, presentBanner: true, presentList: true),
);

class LocalNotificationsTimerScheduler implements TimerNotificationScheduler {
  LocalNotificationsTimerScheduler({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _initialized;

  /// Lazy so nothing touches the platform channel until a timer is actually used.
  Future<void> _ensureInitialized() => _initialized ??= _initialize();

  Future<void> _initialize() async {
    // Notifications are scheduled for an absolute instant, so UTC is enough; no device time zone lookup.
    tz_data.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(_androidIcon),
        // Permissions are requested when the first timer starts, not at launch.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestSoundPermission: false,
          requestBadgePermission: false,
        ),
      ),
    );
  }

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  IOSFlutterLocalNotificationsPlugin? get _ios =>
      _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

  @override
  Future<void> requestNotificationPermission() async {
    await _ensureInitialized();
    await _android?.requestNotificationsPermission();
    await _ios?.requestPermissions(alert: true, sound: true);
  }

  @override
  Future<bool> canScheduleExact() async {
    await _ensureInitialized();
    return await _android?.canScheduleExactNotifications() ?? true;
  }

  @override
  Future<void> requestExactAlarms() async {
    await _ensureInitialized();
    await _android?.requestExactAlarmsPermission();
  }

  @override
  Future<void> schedule({required int id, required String label, required int atMs}) async {
    await _ensureInitialized();
    // Without the exact-alarm permission the OS may delay delivery by minutes; that beats not ringing at all.
    final exact = await canScheduleExact();
    await _plugin.zonedSchedule(
      id: id,
      scheduledDate: tz.TZDateTime.fromMillisecondsSinceEpoch(tz.UTC, atMs),
      notificationDetails: _details,
      androidScheduleMode: exact ? AndroidScheduleMode.exactAllowWhileIdle : AndroidScheduleMode.inexactAllowWhileIdle,
      title: 'Hết giờ!',
      body: label,
    );
  }

  @override
  Future<void> cancel(int id) async {
    await _ensureInitialized();
    await _plugin.cancel(id: id);
  }
}
