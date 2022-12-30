import 'dart:io';
import 'package:companion/houseno.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'google_sign_in.dart';
import 'package:provider/provider.dart';
import 'contents.dart';
import 'package:hive/hive.dart';
import 'logged_in.dart';

import 'notifications/app_notification.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic seen;
    var mybox2 = Hive.box('control');
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              seen = mybox2.get('seen');
              if (seen != null) {
                if (AppNotification.child != null) {
                  final temp = AppNotification.child;
                  Future(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => temp!));
                    AppNotification.child = null;
                  });
                }
                return logged_in();
              } else {
                mybox2.put('seen', true);
                return homeno();
              }
            } else {
              return contents();
            }
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(
                    color: Color.fromARGB(255, 210, 20, 20),
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return contents();
          }
        }),
      ),
    );
  }
}
