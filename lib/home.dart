import 'package:companion/houseno.dart';
import 'package:companion/logged_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'contents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

String? house = "";
String? phone = "";
// var mybox2 = Hive.box('control');
void fetchdata() async {
  final user = FirebaseAuth.instance.currentUser!;
  DocumentSnapshot variable = await FirebaseFirestore.instance
      .collection('UserInfo')
      .doc(user.uid)
      .get();
  house = variable['house number'].toString();
  phone = variable['phone number'].toString();
}

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
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              fetchdata();
              if (house == "" || phone == "") {
                return HomeNo();
              } else {
                return const LoggedIn();
              }
            } else {
              return const Contents();
            }
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(
                    color: Color.fromARGB(255, 210, 20, 20),
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            );
          }
          // else if(snapshot.hasData){
          //   return logged_in();
          // }
          else {
            return const Contents();
          }
        }),
      ),
    );
  }
}
