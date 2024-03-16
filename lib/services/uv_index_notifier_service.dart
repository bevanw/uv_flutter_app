import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class UVIndexNotifierService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  UVIndexNotifierService(this._flutterLocalNotificationsPlugin);

  void showUvIndexNotification(String message) async {
    await _flutterLocalNotificationsPlugin.show(
      1,
      'UV Index Notification',
      'Refresh the UV index data',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'uv_index_notification_channel',
          'UV Index Notification',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: message,
    );
  }
}
