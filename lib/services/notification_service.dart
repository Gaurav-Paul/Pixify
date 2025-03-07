import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import "package:googleapis_auth/auth_io.dart" as auth;
import 'package:pixify/features/messaging/messages_page.dart';
import 'package:pixify/main.dart';

@pragma('vm:entry-point')
Future handleBackgroundMessage(RemoteMessage message) async {}

class NotificationService {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static const String fcmApiURL =
      "https://fcm.googleapis.com/v1/projects/pixify-f1e57/messages:send";

  final androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    "High Importance Notifications",
    description: "This channel is used for important notifications",
    importance: Importance.max,
  );

  final localNotifications = FlutterLocalNotificationsPlugin();

  Future getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  initNotification() async {
    await messaging.requestPermission();

    initPushNotification();
    initLocalNotification();
  }

  handleMessage(RemoteMessage? message) async {
    if (message == null) {
      return;
    }

    navigatorKey.currentState!.pushNamed(
      MessagesPage.route,
      arguments: message,
    );
  }

  initPushNotification() async {
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    messaging.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(
      (message) {
        final notification = message.notification;
        if (notification == null) {
          return;
        } else {
          localNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                androidChannel.id,
                androidChannel.name,
                channelDescription: androidChannel.description,
                icon: "@drawable/notification_icon",
              ),
            ),
            payload: jsonEncode(message.toMap()),
          );
        }
      },
    );
  }

  initLocalNotification() async {
    const android =
        AndroidInitializationSettings("@drawable/notification_icon");
    const settings = InitializationSettings(android: android);
    await localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) =>
          handleMessage(RemoteMessage.fromMap(jsonDecode(details.payload!))),
    );

    final platform = FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await platform?.createNotificationChannel(androidChannel);
  }

  static Future<String> getAccessToken() async {}

  static Future<void> sendNotification({
    required String fcmToken, // FCM token of the recipient device
    required String title,
    required String body,
    Map<String, dynamic>? data, // Optional custom data payload
  }) async {
    try {
      final String serverKey = await getAccessToken();

      print("Notification to: $fcmToken");
      print("Sent Notification title: $title");
      print("Sent Notification body: $body");

      final Map<String, dynamic> message = {
        "message": {
          "token": fcmToken,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": data ?? {},
        }
      };

      final http.Response response = await http.post(
        Uri.parse(fcmApiURL),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $serverKey"
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print("Notification wasn't sent :( \nStatus Code: ${response.body}");
      }
    } catch (e) {
      print("Error occured while sending the notification: $e");
    }
  }
}
