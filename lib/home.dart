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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}
dynamic seen;
var mybox2=Hive.box('control');
class HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
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
              seen=mybox2.get('seen');
              if(seen!=null)
              {
                return logged_in();
              }
              else
              {
                mybox2.put('seen',true);
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
          }
          else {
            return contents();
          }
        }),
      ),
    );
  }
}
