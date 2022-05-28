import 'package:flutter/Material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() => _notificationService;

  NotificationService._internal();

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {

    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  }

  Future<void> showNotification( int id, String title, String body, int seconds ) async 
  {

    await flutterLocalNotificationsPlugin.zonedSchedule
    (
      id,
      title,
      body,

      tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),

      const NotificationDetails
      (
        android: AndroidNotificationDetails
        (
          
          "main_channel", 
          "Main Channel",
          channelDescription: "Main channel notifications",
          importance: Importance.max,
          priority: Priority.max,
          icon: "@mipmap/ic_launcher"

        )
      ),

      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,

      androidAllowWhileIdle: true

    );
  
  }
}
