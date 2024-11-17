import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  NotificationService._();

  Future<void> initialize() async {
    // Initialize timezone data
    tz.initializeTimeZones();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );
  }

  Future<void> scheduleNotification(
      String id, String title, String body, DateTime scheduledDate) async {
    try {
      await _notifications.zonedSchedule(
        id.hashCode,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'task_manager_channel', 'Task Manager Notifications',
              channelDescription: 'Notifications for task reminders',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher'),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  Future<void> cancelNotification(String id) async {
    await _notifications.cancel(id.hashCode);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final NotificationService _instance = NotificationService._();
//   static NotificationService get instance => _instance;

//   final FlutterLocalNotificationsPlugin _notifications =
//       FlutterLocalNotificationsPlugin();

//   NotificationService._();

//   Future<void> initialize() async {
//     // Initialize timezone
//     tz.initializeTimeZones();

//     // Initialize notification settings for Android
//     const androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     // Initialize notification settings for iOS
//     const iosSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     // Combined initialization settings
//     const initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );

//     // Initialize the plugin
//     await _notifications.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) async {
//         // Handle notification tap
//         debugPrint('Notification tapped: ${response.payload}');
//       },
//     );

//     // Request permissions for iOS
//     await _notifications
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }

//   // Schedule a notification
//   Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//     String? payload,
//     NotificationDetails? customDetails,
//   }) async {
//     final details = customDetails ?? await _getNotificationDetails();

//     await _notifications.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledDate, tz.local),
//       details,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       payload: payload,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }

//   // Show an immediate notification
//   Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//     String? payload,
//     NotificationDetails? customDetails,
//   }) async {
//     final details = customDetails ?? await _getNotificationDetails();

//     await _notifications.show(
//       id,
//       title,
//       body,
//       details,
//       payload: payload,
//     );
//   }

//   // Cancel a specific notification
//   Future<void> cancelNotification(int id) async {
//     await _notifications.cancel(id);
//   }

//   // Cancel all notifications
//   Future<void> cancelAllNotifications() async {
//     await _notifications.cancelAll();
//   }

//   // Get pending notification requests
//   Future<List<PendingNotificationRequest>> getPendingNotifications() async {
//     return await _notifications.pendingNotificationRequests();
//   }

//   // Get default notification details
//   Future<NotificationDetails> _getNotificationDetails() async {
//     // Android notification details
//     const androidDetails = AndroidNotificationDetails(
//       'task_manager_channel', // Channel ID
//       'Task Manager Notifications', // Channel name
//       channelDescription: 'Notifications for task manager app',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//       styleInformation: BigTextStyleInformation(''),
//       enableVibration: true,
//       enableLights: true,
//       color: Color.fromARGB(255, 255, 0, 0),
//       ledColor: Color.fromARGB(255, 255, 0, 0),
//       ledOnMs: 1000,
//       ledOffMs: 500,
//     );

//     // iOS notification details
//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//       sound: 'default',
//       badgeNumber: 1,
//     );

//     return const NotificationDetails(android: androidDetails, iOS: iosDetails);
//   }

//   // Helper method to create notification schedule time
//   tz.TZDateTime _nextInstanceOfTime(DateTime scheduledDate) {
//     final now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(scheduledDate, tz.local);

//     if (scheduledTZDate.isBefore(now)) {
//       scheduledTZDate = scheduledTZDate.add(const Duration(days: 1));
//     }
//     return scheduledTZDate;
//   }

//   // Schedule a repeating notification
//   Future<void> scheduleRepeatingNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//     required RepeatInterval repeatInterval,
//     String? payload,
//   }) async {
//     final details = await _getNotificationDetails();

//     await _notifications.periodicallyShow(
//       id,
//       title,
//       body,
//       repeatInterval,
//       details,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       payload: payload,
//     );
//   }

//   // Schedule a notification with custom sound
//   Future<void> scheduleNotificationWithCustomSound({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//     required String soundFile, // e.g., 'notification_sound.wav'
//     String? payload,
//   }) async {
//     final androidDetails = AndroidNotificationDetails(
//       'task_manager_channel',
//       'Task Manager Notifications',
//       channelDescription: 'Notifications for task manager app',
//       importance: Importance.max,
//       priority: Priority.high,
//       sound: RawResourceAndroidNotificationSound(soundFile.split('.').first),
//     );

//     final iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//       sound: soundFile,
//     );

//     final details =
//         NotificationDetails(android: androidDetails, iOS: iosDetails);

//     await _notifications.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledDate, tz.local),
//       details,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       payload: payload,
//     );
//   }
// }
