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

  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "pixify-f1e57",
      "private_key_id": "c17383026062e0b7cdddd2d5067e2c980583f60c",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDMV8py7lgKeLe7\n03G4FDIPD8NAFLisesBAQciTD136z7hmXSJWkJDUiiyY5w0mZQTdJDINDk3NMsLr\nf0gTtDQJCuMmoXCMzu61FiH2r8x05439NbSHWXNnp236/KBiLeMw1+zEsRuJrAuF\nYlhgvIgV6IJl8oyI6zBbP9uKRl/ObVf1Sy+meOiBLCcs/AYCY5zPERLsJm6k8DYk\naSyN3iMUlyFA8efoaVCSfakKTxeSckI9v6Cx2TEUNEWTBKF3XyXtNKeh9D395g9i\n/LfaLOftKB0jEVSsQno0bUl2g7skBk+C1Zyc5oVSi42OVkiZnpG/Gh10RJOUTFRc\n1Ig14zBZAgMBAAECggEADYmYZC5Vn1X5iCQ9Ma6G1XgcHZPx2x1jvK4PAW0gcwQN\naZyscHMx4R7JTxTpilxhatwhw7spnNlK0Aq15fZHhzzVKSNDX1S7PDx74gmqACmx\n/q8u51OeAWU2dE0FvBNhrIP1j99S3XdMKRlHlRsQYfEuKF5eAJkiMj1kCEBaywRV\nnsKRJIpIYC20sAFKAppCoaBkLbmhUcqkIQotIKtvUPEKtpCDV7HfVaxwjbYFHIEX\n2p0DLtsJS2F1SlkkqynxeR7a4S2hiAPZpNZp3+06/9QwrBMOSW5LG6pGaVYQKfT1\nDbDNc7BcG3l4hy8m+no+XkPat2TQIWnGRXk+x1xjAQKBgQDtW/5mzoWSmOK9ugrR\nbxz5jugIkBeOeCIjrRDVtA03om2IdZAjTZuO82jklFy5aC8CRnCZdTHZ6W/i++Kb\n8VDY8svzIOascDi/lEFbtHOmImMIbtOTC2CCesFmV9YAROHPHLiJdVV4eF+eDu7E\nRGiZG9h1OII9LTsGnPBieCJ02QKBgQDcZAQxXOK6Vl1g6p9dWqu6zExApHIbVWrq\nszudXT1WcMU/m4kK3GMAz8hafxTi1D0+etUMDNZEBh8xHhoLwWylru66A+ANTpCS\nrLFDziiF/kq0UH4uU5BCG9nI7xjz/YQMrSv4GybAxWH9Og3Pj6x3HI75AxRtLaEL\nDGie/btngQKBgHcMGs6pamkacS7DbsWYOyoXuN0CmC4GpujJ1pW4lqB+wP0eKcrr\nE8hg4Q00NEVxsZIsjjEJjJVE9a8cso2QPQJy1EP/DnMSXgQIcbdzDEYZHR6Pp2Iq\n5J7Mvs974oOECNV+DDg1N0cS6LI3vx2FSgjw5GH2k6vnUaGBeTeKFY4RAoGBAKM/\nzr9F34hJavfcM1nyTNyccis75G4M0pqxUwpYw5OhCur36gZKg2dZgj5OfgkbT5ZV\nZDR92cUfh8FZW8+zYihEMP9G2ZLhzENpehEQx4GhgHKaYS0tpuDhQmwNd71b35GI\nQNaSPh1y2Ae8FfjWotjEJb+cIWhR8UV+1oxWxJeBAoGAKlNdWqqbm57DZ69KDmRf\nV5lyz/YWO8XkfSZthDzHhf4+32nfxYcawqoGP3dMgjYhiT62loPOAa2xL71+9Xkx\nBpjRSoGRCTAsbdJxX0wcpYqtVuvD6cBAxmiFDsJOmsxP+PkAU+HwkWEetSyvRFGx\nVsjtXmJMdOlGukNm7UEsf9E=\n-----END PRIVATE KEY-----\n",
      "client_email": "pixify@pixify-f1e57.iam.gserviceaccount.com",
      "client_id": "116701975246715582053",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/pixify%40pixify-f1e57.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    var credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();
    return credentials.accessToken.data;
  }

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
