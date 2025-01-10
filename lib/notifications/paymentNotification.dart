import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  late FlutterLocalNotificationsPlugin _localNotifications;

  NotificationService() {
    _initializeLocalNotifications();
  }

  void _initializeLocalNotifications() {
    _localNotifications = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = 
        InitializationSettings(android: androidSettings);

    _localNotifications.initialize(initSettings);
  }

  Future<void> showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'payment_channel', 
      'Payment Notifications',
      channelDescription: 'Notification for payment actions',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      0, // ID unik untuk notifikasi
      title,
      body,
      notificationDetails,
    );
  }
}
