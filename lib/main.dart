import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'notifications/app_notification.dart';

void main() async {
  AppNotification.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AppNotification.listenForMessage();
  FirebaseMessaging.onBackgroundMessage(AppNotification.bacgroundMessage);
  FirebaseMessaging.instance.getToken().then((v) {
    debugPrint(v);
  });

  // await Hive.initFlutter();
  // var box = await Hive.openBox('testBox');
  // var box2 = await Hive.openBox('control');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // void listenFCM() async {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //     if (notification != null && android != null && !kIsWeb) {
  //       flutterLocalNotificationsPlugin.show(
  //           notification.hashCode,
  //           notification.title,
  //           notification.body,
  //           NotificationDetails(
  //               android: AndroidNotificationDetails(channel.id, channel.name,
  //                   icon: 'launch_background',
  //                   playSound: true,
  //                   sound:
  //                       RawResourceAndroidNotificationSound('alarm_sound'))));
  //     }
  //   });
  // }

  // void loadFCM() async {
  //   if (!kIsWeb) {
  //     channel = const AndroidNotificationChannel(
  //         'high_importance_channel', 'High Importance Notifications',
  //         importance: Importance.high,
  //         enableVibration: true,
  //         playSound: true,
  //         sound: RawResourceAndroidNotificationSound('alarm_sound'));
  //     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //     await flutterLocalNotificationsPlugin
  //         .resolvePlatformSpecificImplementation<
  //             AndroidFlutterLocalNotificationsPlugin>()
  //         ?.createNotificationChannel(channel);
  //     // await FirebaseMessaging.instance.

  //     await FirebaseMessaging.instance
  //         .setForegroundNotificationPresentationOptions(
  //             alert: true, badge: true, sound: true);
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: const MaterialApp(
        home: Home(),
      ),
    );
  }
}
