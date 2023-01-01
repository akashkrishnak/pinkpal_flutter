import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'google_sign_in.dart';
import 'package:provider/provider.dart';

import 'package:location/location.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'houseno.dart';
import 'home.dart';

class logged_in extends StatefulWidget {
  const logged_in({super.key});
  @override
  State<logged_in> createState() => logged_inState();
}

// Future<void> _createNotificationChannel(
//     String id, String name, String sound) async {
//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   var androidNotificationChannel = AndroidNotificationChannel(
//     id,
//     name,
//     description: "important message",
//     sound: RawResourceAndroidNotificationSound(sound),
//     playSound: true,
//   );

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(androidNotificationChannel);
// }

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
  static String? housenumber = "";
  static String? phone;
  // void getvalue() async {
  //   setState(() {
  //     housenumber = mybox.get(2);
  //     phone = mybox.get(1);
  //   });
  // }

  fetchdata() async {
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(user.uid)
        .get();
    setState(() {
      housenumber = variable['house number'].toString();
      phone = variable['phone number'].toString();
    });
  }

  @override
  void initState() {
    super.initState();
    // getvalue();
    // gettoken();
    fetchdata();
    // _createNotificationChannel("channel_id_2", "channel_name", "alarm_sound");
    // getlocation();
  }

  Future<String> sendpushnotification() async {
    final notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);
    try {
      final response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-type': 'application/json',
                'Authorization':
                    'key=AAAAJOLX8K4:APA91bGOCsk6LTy6nkbZU9EPLAy1ckgi4aGZG_cqaQUru5GOojuVmvoa67mSCI2_UPU6U6EEuN8aPQ5pNaIWUYHvyv_MYTsysoFRla-Ge7Wo9fH5PivI-AeEb0claglhrVCsfCAWfAED',
              },
              body: jsonEncode(<String, dynamic>{
                'priority': 'high',
                'data': <String, dynamic>{
                  "body":
                      "${user.displayName} needs help!!!\nHouse number:$housenumber",
                  "title": "Emergency!!!",
                  "channel_key": "emergency_channel",
                  "category": "call",
                  "color": "FFFFFF",
                  "largeIcon": user.photoURL,
                  "expire": DateTime.now()
                      .add(const Duration(minutes: 10))
                      .toString(),
                  "notification_id": notificationId,
                  "fullScreenIntent": true,
                  "buttons": [
                    {
                      "key": "accept",
                      "label": "Help", //button text
                      "color": "19E567",
                      "action": {
                        "type": "emergency",
                        "arguments": [
                          user.displayName,
                          housenumber,
                          phone,
                          user.photoURL
                        ]
                      }
                    },
                    {
                      "key": "reject",
                      "label": "Ignore", //button text
                      "color": "D0342C",
                      "action_type": "dismissAction",
                      "isDangerousOption": true
                    }
                  ]
                },
                "to": "/topics/emercall"
              }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return "Alert has been sent";
      }
      return response.body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> sendmednotification() async {
    final notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);

    try {
      final response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-type': 'application/json',
                'Authorization':
                    'key=AAAAJOLX8K4:APA91bGOCsk6LTy6nkbZU9EPLAy1ckgi4aGZG_cqaQUru5GOojuVmvoa67mSCI2_UPU6U6EEuN8aPQ5pNaIWUYHvyv_MYTsysoFRla-Ge7Wo9fH5PivI-AeEb0claglhrVCsfCAWfAED',
              },
              body: jsonEncode(<String, dynamic>{
                'priority': 'high',
                'data': <String, dynamic>{
                  'body': '${user.displayName} has medical emergency!!\nHouse number: $housenumber',
                  'title': 'Emergency!!!',
                  "expire": DateTime.now()
                      .add(const Duration(minutes: 10))
                      .toString(),
                  "channel_key": "emergency_channel",
                  "category": "call",
                  "color": "FFFFFF",
                  "largeIcon": user.photoURL,
                  "notification_id": notificationId,
                  "fullScreenIntent": true,
                  "buttons": [
                    {
                      "key": "accept",
                      "label": "Help", //button text
                      "color": "19E567",
                      "action": {
                        "type": "emergency",
                        "arguments": [
                          user.displayName,
                          housenumber,
                          phone,
                          user.photoURL
                        ]
                      }
                    },
                    {
                      "key": "reject",
                      "label": "Ignore", //button text
                      "color": "D0342C",
                      "action_type": "dismissAction",
                      "isDangerousOption": true
                    }
                  ]
                },
                "to": "/topics/emercall"
              }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return "Alert has been sent";
      }
      return response.body;
    } catch (e) {
      return e.toString();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      // ignore: sort_child_properties_last
      child: Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.32,
                    child: DrawerHeader(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 54, 174, 244),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(50))),
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: Column(
                            children: [
                              Text('User Account',
                                  style: GoogleFonts.quicksand(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.01),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                    user.photoURL!,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    )),
                ListTile(
                  title: Text(
                    user.displayName!,
                    style: GoogleFonts.quicksand(
                        fontSize: 18, fontWeight: FontWeight.w400),
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
                        color: Color.fromARGB(255, 54, 174, 244),
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                ListTile(
                  title: Text(
                    "+91 ${phone}",
                    style: GoogleFonts.quicksand(
                        color: Color.fromARGB(255, 54, 174, 244),
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                ListTile(
                  title: Text(
                    "Edit Info",
                    style: GoogleFonts.quicksand(
                        color: Color.fromARGB(255, 54, 174, 244),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => homeno()),
                    ).then((result) {
                      if (result != null) {
                        setState(() {
                          // use the returned value to update the state of the parent screen
                        });
                      }
                    });
                  },
                ),
                ListTile(
                  title: Text(
                    "Sign Out",
                    style: GoogleFonts.quicksand(
                        color: Color.fromARGB(255, 54, 174, 244),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // mybox2.put(1, 0);
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.logout();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                )
              ],
            ),
          ),
          appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.red),
              toolbarHeight: MediaQuery.of(context).size.height * 0.13,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(
                          MediaQuery.of(context).size.width * 0.8, 50.0))),
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Image.asset('assets/icon1.png'),
                      ),
                    ],
                  ),
                  // Text(
                  //   "Companion",
                  //   style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 25,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(user.photoURL!),
                    ),
                  ),
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.05),
                child: Text(
                  "Hold the button to trigger call",
                  style: GoogleFonts.quicksand(color: Colors.red, fontSize: 18),
                ),
              ),
              Column(
                children: [
                  MaterialButton(
                      color: Colors.red,
                      shape: CircleBorder(),
                      onLongPress: () async {
                        final msg = await sendpushnotification();
                        // latitude = currentlocation!.latitude!.toString();
                        // longitude = currentlocation!.longitude!.toString();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const location()),
                        // );
                        showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.elliptical(200, 50),
                              ),
                            ),
                            builder: ((context) {
                              return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.13,
                                  child: Center(
                                    child: Text(
                                      msg,
                                      style: GoogleFonts.quicksand(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ));
                            }));
                      },
                      onPressed: () {
                        print(user.uid);
                      },
                      child: SvgPicture.asset(
                        "assets/sos.svg",
                        width: MediaQuery.of(context).size.height * .25,
                      )),
                  const SizedBox(
                    height: 32,
                  ),
                  MaterialButton(
                      color: Color.fromARGB(255, 54, 146, 244),
                      shape: CircleBorder(),
                      onLongPress: () async {
                        final msg = await sendmednotification();
                        // latitude = currentlocation!.latitude!.toString();
                        // longitude = currentlocation!.longitude!.toString();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const location()),
                        // );
                        showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.elliptical(200, 50),
                              ),
                            ),
                            builder: ((context) {
                              return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.13,
                                  child: Center(
                                    child: Text(
                                      msg,
                                      style: GoogleFonts.quicksand(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ));
                            }));
                      },
                      onPressed: () {
                        print(user.uid);
                      },
                      child: SvgPicture.asset(
                        "assets/medical-sos.svg",
                        width: MediaQuery.of(context).size.height * .25,
                      ))
                ],
              )
            ],
          )),
      color: Color.fromARGB(255, 146, 143, 143),
    );
  }
}
