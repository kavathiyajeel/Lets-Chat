import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../chat_room/chat_room.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel androidNotificationChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  void requestNotificationPermission() async {
    await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    initLocalNotification();
  }

  void initLocalNotification() async {
    var androidInitializationSettings = const AndroidInitializationSettings('@drawable/ic_notification');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings =
        InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      // handleMessage(context, payload);
    });
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      // debugPrint(message.notification!.title.toString());
      // debugPrint(message.notification!.body.toString());
      // debugPrint(message.data.toString());

      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    await flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification!.title ?? 'empty',
        message.notification!.body ?? 'empty',
        NotificationDetails(
          android: AndroidNotificationDetails(androidNotificationChannel.id, androidNotificationChannel.name,
              channelDescription: androidNotificationChannel.description,
              icon: '@drawable/ic_notification',
              importance: Importance.max,
              priority: Priority.max,
              playSound: true,
              fullScreenIntent: true),
          iOS: const DarwinNotificationDetails(),
          macOS: const DarwinNotificationDetails(),
        ),
        payload: jsonEncode(message.data));
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    debugPrint("senderId: ${message.data["senderUid"]}");
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    DatabaseReference ref2 = databaseReference.child('Users');
    ref2.child(message.data['senderUid']).onValue.listen((event) async {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatRoom(userData: {
                    'uid': values['uid'],
                    'email': values['email'],
                    'full_name': values['full_name'],
                    'image': values['image']
                  })));
    });
  }
}
