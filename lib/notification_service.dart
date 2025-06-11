import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService(this.flutterLocalNotificationPlugin);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin;

  Future<void> initializeNotificationService() async {
    final androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    // no actions for now
    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    // android and ios for now
    final initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationPlugin.initialize(initializationSettings);
  }

  Future<void> showNotificaion(int notificationId) async {
    final androidNotificationDetails = AndroidNotificationDetails(
      "android_channel_id",
      "android_channel_name",
      channelDescription: "android channel description",
      importance: Importance.max,
      priority: Priority.high,
      ticker: "ticker",
    );

    final iosNotificationDetails = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    notificationId = notificationId + 1;

    await flutterLocalNotificationPlugin.show(
      notificationId++,
      "Test notification title",
      "Test notification body",
      notificationDetails,
      payload: "item x", // not necessary
    );
  }
}
