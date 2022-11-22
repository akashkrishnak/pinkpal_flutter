import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  await Hive.initFlutter();
  var box = await Hive.openBox('testBox');
  var box2=await Hive.openBox('control');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    loadFCM();
    listenFCM();
    gettoken();
    FirebaseMessaging.instance.subscribeToTopic("emercall");
  }

  void gettoken() async{
    await FirebaseMessaging.instance.getToken().then((value) => 
      print(value)
    );
  }

  void listenFCM() async{
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification=message.notification;
      AndroidNotification? android=message.notification?.android;
      if(notification!=null && android!=null && !kIsWeb)
      {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background'
            )
          )
        );
      }
    });
  }

  void loadFCM()async{
    if(!kIsWeb){
      channel=const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.high,
        enableVibration: true,
      );
      flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true
        );
    }
  }

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        home: Home(),
      ),
    );
  }
}
