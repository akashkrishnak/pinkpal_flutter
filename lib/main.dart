import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

  await Hive.initFlutter();
  var box = await Hive.openBox('testBox');
  var box2 = await Hive.openBox('control');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
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
