import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../helpers/auth_helper.dart';

class CustomNotificationSettings{

  // static final NotificationSettings instance = NotificationSettings._createInstance();
  // NotificationSettings._createInstance();

  static void init() async{
    final fcmToken = await FirebaseMessaging.instance.getToken();
    await Supabase.instance.client.from("users").update({"fcm_token":fcmToken}).match({"id":AuthHelper().getUID()});

    // 以降はテスト

    AndroidNotificationChannel channelA = const AndroidNotificationChannel(
      'message', // チャネルID
      'messages', // チャネル名
      groupId: "main",
      // importance: Importance.high,
    );

    AndroidNotificationChannel channelB = const AndroidNotificationChannel(
      'post', // チャネルID
      'posts', // チャネル名
      groupId: "main",
      // importance: Importance.high,
    );
    AndroidNotificationChannelGroup channelGroup = const AndroidNotificationChannelGroup("main", "Main");

    final FlutterLocalNotificationsPlugin notificationPlugin = FlutterLocalNotificationsPlugin();
    // await notificationPlugin.initialize(InitializationSettings(android: AndroidInitializationSettings()),);

    await notificationPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannelGroup(channelGroup);

    await notificationPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channelA);

    await notificationPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channelB);

  }
}