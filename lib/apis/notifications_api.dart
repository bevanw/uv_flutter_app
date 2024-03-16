import 'dart:io' show Platform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

/// TODO: Unit tests
class NotificationsApi {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isPermissionsGranted = false;

  bool get isPermissionsGranted {
    return _isPermissionsGranted;
  }

  Future<void> initialise() async {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
    );

    await _notifications.initialize(initializationSettings);

    _isPermissionsGranted = await _requestPermissions() ?? false;
  }

  Future<bool?> _requestPermissions() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
      return await androidImplementation?.requestNotificationsPermission();
    } else if (Platform.isIOS) {
      return await _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
    return false;
  }

  /// Shows a scheduled notification at the [scheduledDate]. [id] must be a unique ID, recommended to use a UUID package
  void showScheduledNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async {
    // TODO: Fill this in (https://stackoverflow.com/questions/77910539/how-to-schedule-a-notification-based-on-user-input-using-flutter-for-android)
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'channelID',
        'channelName',
        channelDescription: 'channelDescription',
      ),
      iOS: DarwinNotificationDetails(),
    );

    // might need a background worker? how will we get it to call the API and then display this?
    _notifications.zonedSchedule(id, title, body, TZDateTime.from(scheduledDate, local), details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, payload: payload);
  }

  void cancel(int id) => _notifications.cancel(id);
  void cancelAll() => _notifications.cancelAll();
}
