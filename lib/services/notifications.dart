import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:orange_chat/models/supabase/posts.dart';
import 'package:orange_chat/models/supabase/rooms.dart';
import 'package:orange_chat/views/posts/posts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../helpers/auth_helper.dart';
import '../views/chats/chat_room.dart';

class CustomNotificationSettings{

  // static final NotificationSettings instance = NotificationSettings._createInstance();
  // NotificationSettings._createInstance();

  static void init(BuildContext context) async{
    final firebaseMessaging = FirebaseMessaging.instance;
    // パーミッションの確認
    firebaseMessaging.requestPermission();

    final fcmToken = await firebaseMessaging.getToken();
    await Supabase.instance.client.from("users").update({"fcm_token":fcmToken}).match({"id":AuthHelper().getUID()});

    // 通知をクリックしたときの処理
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      switch(message.notification?.android?.channelId){
        case "message":
          final RoomModel roomModel = RoomModel.fromMap(message.data);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatRoomScreen(room: roomModel)));
          break;
      }
    });

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