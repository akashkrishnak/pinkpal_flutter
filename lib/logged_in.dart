import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'google_sign_in.dart';
import 'package:provider/provider.dart';
import 'contents.dart';
import 'logged_in.dart';
import 'package:location/location.dart';
import 'location.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'houseno.dart';
import 'package:shared_preferences/shared_preferences.dart';

class logged_in extends StatefulWidget {
  const logged_in({super.key});
  @override
  State<logged_in> createState() => logged_inState();
}

LocationData? currentlocation;
void getlocation() {
  Location location = Location();
  location.getLocation().then((location) {
    currentlocation = location;
  });
}

class logged_inState extends State<logged_in> {
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = "";
  static String latitude = "";
  static String longitude = "";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;
  static String? housenumber = "";
  static String? phone;
  void getvalue() async {
    prefs = await _prefs;
    setState(() {
      housenumber = prefs.containsKey("house") ? prefs.getString("house") : "";
      phone=prefs.containsKey("phone")?prefs.getString("phone"):"";
    });
  }
  @override
  void initState() {
    super.initState();
    getvalue();
    gettoken();
    getlocation();
  }

  void sendpushnotification() async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-type': 'application/json',
            'Authorization':
                'key=AAAAJOLX8K4:APA91bGOCsk6LTy6nkbZU9EPLAy1ckgi4aGZG_cqaQUru5GOojuVmvoa67mSCI2_UPU6U6EEuN8aPQ5pNaIWUYHvyv_MYTsysoFRla-Ge7Wo9fH5PivI-AeEb0claglhrVCsfCAWfAED',
          },
          body: jsonEncode(<String, dynamic>{
            'notification': <String, dynamic>{
              'body': '${user.displayName} needs help!!!\nHouse number: ${housenumber}',
              'title': 'Emergency!!!'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'sound':'assets/sound.wav',
              'screen':'homeno()',
              'id': '1',
              'status': 'done'
            },
            "to": "/topics/emercall"
          }));
    } catch (e) {
      print("Error sending push notification");
    }
  }

  void gettoken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        token = token;
      });
      savetoken(token!);
    });
  }

  void savetoken(String token) async {
    await FirebaseFirestore.instance.collection("UserTokens").doc("User1").set({
      'token': token,
    });
  }

  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.32,
                  child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.red,
                      ),
                      child: Column(
                        children: [
                          Text('User Account',
                              style: GoogleFonts.quicksand(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.01),
                            child: CircleAvatar(
                              radius: 65,
                              backgroundImage: NetworkImage(user.photoURL!),
                            ),
                          ),
                        ],
                      )),
                ),
                ListTile(
                  title: Text(
                    "${user.displayName!}",
                    style: GoogleFonts.quicksand(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                ListTile(
                  title: Text("${user.email!}",
                      style: GoogleFonts.quicksand(
                          fontSize: 18, fontWeight: FontWeight.w400)),
                ),
                ListTile(
                  title: Text(
                    "House No: ${housenumber}",
                    style: GoogleFonts.quicksand(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                ListTile(
                  title: Text(
                    "+91 ${phone}",
                    style: GoogleFonts.quicksand(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Edit Info",
                    style: GoogleFonts.quicksand(
                        color: Colors.red,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    prefs.setInt("control",0);
                    Navigator.push(context,MaterialPageRoute(builder: ((context) => homeno())));
                  },
                ),
                ListTile(
                  title: Text(
                    "Sign Out",
                    style: GoogleFonts.quicksand(
                        color: Colors.red,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.logout();
                  },
                )
              ],
            ),
          ),
          appBar: AppBar(
              backgroundColor: Colors.red,
              title: Row(
                children: [
                  Text(
                    "Pal",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  )
                ],
              )),
          body: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    "Welcome, \n${user.displayName!}",
                    style: GoogleFonts.quicksand(
                        color: Color.fromARGB(255, 197, 79, 70),
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.4),
                child: Text(
                  "Hold the button to trigger call",
                  style: GoogleFonts.quicksand(color: Colors.red, fontSize: 18),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                      child: SizedBox(
                    height: MediaQuery.of(context).size.height * .27,
                    width: MediaQuery.of(context).size.width * .65,
                    child: MaterialButton(
                        color: Colors.red,
                        shape: CircleBorder(),
                        onLongPress: () {
                          sendpushnotification();
                          latitude = currentlocation!.latitude!.toString();
                          longitude = currentlocation!.longitude!.toString();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const location()),
                          );
                        },
                        onPressed: () {
                        },
                        child: Padding(
                          padding: EdgeInsets.all(.01),
                          child: Text(
                            "Emergency",
                            style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.08,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  )))
            ],
          )),
    );
  }
}
