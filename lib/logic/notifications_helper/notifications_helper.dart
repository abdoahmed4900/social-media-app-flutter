import 'dart:convert';

import 'package:chat_app/constants/methods.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../../cache/cache_helper/cache_helper.dart';
import '../../constants/constants.dart';

class NotificationsHelper {
  static late FirebaseMessaging messaging;
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static Future<void> init() async {
    messaging = FirebaseMessaging.instance;
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    requestPermission();
  }

  static Future getToken() async {
    token = CacheHelper.getString('token');
    if (token.isEmpty) {
      token = (await messaging.getToken())!;
      CacheHelper.setString('token', token);
    }
    debugPrint('token : $token');
    return token;
  }

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
            debugPrint('body : ${details.payload}');
            push(
                Scaffold(
                  body: Center(
                    child: Text(details.payload.toString()),
                  ),
                ),
                context);
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

  static void sendNotification() async {
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'content-type': 'application/json',
          'Authorization':
              'key=AAAAMCKeBcM:APA91bGJLba8TT1RZ8O9M2-9217lhUzJ-CDwhGpK9_gaCVIIqOedUg6-7cICfAhCT_8NVAOwKxLsigbXd-ch2ucBaI3HL2Rl1vwNUZ9AjmQ3qdh3QqW9xZi1Om9X-hUaf383jd7ZjsxV'
        },
        body: jsonEncode({
          "notification": {
            "body": "this is a body",
            "title": "this is a title",
            "android_channel_id": "channel_of_app"
          },
          "priority": "high",
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "id": "1",
            "status": "done",
            "body": "here is the body",
          },
          "to": token
        }));
  }
}
