import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  @override
  void initState() {
    //------------flutter local notications setup pop on screen
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    requestNotificationPermission();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings =
        const InitializationSettings(android: androidInitializationSettings);
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'messages', 'Messages',
        importance: Importance.high);

    createChannel(channel);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    //--firebase listen and show response while app in foreground
    FirebaseMessaging.onMessage.listen((mesg) {
      final notification = mesg.notification;
      final android = mesg.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    icon: android.smallIcon)));
      }
    });
    super.initState();
  }

  Future<void> requestNotificationPermission() async {
    await FirebaseMessaging.instance
        .requestPermission(
      sound: true,
      badge: true,
      alert: true,
      provisional: false,
    )
        .then((NotificationSettings settings) {
      print('User granted permission: $settings');
    });
  }

//--creating a channel for notifications
  void createChannel(AndroidNotificationChannel channel) async {
    final FlutterLocalNotificationsPlugin plugin =
        FlutterLocalNotificationsPlugin();
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('FCM notification'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Notifications'),
        ),
      ),
    );
  }
}
