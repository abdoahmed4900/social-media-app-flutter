import 'dart:convert';

import 'package:chat_app/constants/enums.dart';
import 'package:chat_app/logic/app_bloc/app_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationsHelper {
  static late FirebaseMessaging messaging;
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static Future requestPermission() async {
    final settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('permission denied');
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('permission authorized');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('permission provisional');
    }
  }

  static Future initNotificationSettings(context) async {
    var androidSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidSettings);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        try {
          if (details.payload != null && details.payload!.isNotEmpty) {
            switch (AppBloc.get(context).notificationType) {
              case NotificationType.comment:
                break;
              default:
            }
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      },
    );

    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      'channel_of_app',
      'channel_of_app',
      importance: Importance.max,
      playSound: true,
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    FirebaseMessaging.onMessage.listen((event) async {
      debugPrint('notification ---------------------------------');
      debugPrint('${event.notification!.title} : ${event.notification!.body}');
      debugPrint('----------------------------------------------');

      await flutterLocalNotificationsPlugin.show(0, event.notification!.title,
          event.notification!.body, notificationDetails,
          payload: event.data['body']);

      // BigTextStyleInformation info = BigTextStyleInformation(
      //     contentTitle: event.notification!.title, event.notification!.body!);
    });
  }

  static void sendNotification({
    required String notificationMessage,
    required String receiverNotificationToken,
  }) async {
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'content-type': 'application/json',
          'Authorization':
              'key=AAAAMCKeBcM:APA91bGJLba8TT1RZ8O9M2-9217lhUzJ-CDwhGpK9_gaCVIIqOedUg6-7cICfAhCT_8NVAOwKxLsigbXd-ch2ucBaI3HL2Rl1vwNUZ9AjmQ3qdh3QqW9xZi1Om9X-hUaf383jd7ZjsxV'
        },
        body: jsonEncode({
          "notification": {
            "body": notificationMessage,
            "title": "Socio",
            "android_channel_id": "channel_of_app"
          },
          "priority": "high",
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "id": "1",
            "status": "done"
          },
          "to": receiverNotificationToken,
        }));
  }
}
