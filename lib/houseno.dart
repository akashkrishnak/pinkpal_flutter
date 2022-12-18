import 'package:companion/logged_in.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeNo extends StatefulWidget {
  const HomeNo({Key? key}) : super(key: key);

  @override
  State<HomeNo> createState() => HomeNoState();
}

// var mybox = Hive.box('testBox');
void pop(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Alert',
            style: GoogleFonts.quicksand(
                color: Colors.red, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            height: 60,
            child: Center(
              child: Text(
                'Enter the details',
                style: GoogleFonts.quicksand(color: Colors.red, fontSize: 20),
              ),
            ),
          ));
    },
  );
}

final FirebaseAuth firebaseauth = FirebaseAuth.instance;
final user = FirebaseAuth.instance.currentUser!;

class HomeNoState extends State<HomeNo> {
  TextEditingController house = TextEditingController();
  TextEditingController phno = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Enter house number & phone number",
              style: GoogleFonts.quicksand(
                  color: Colors.red, fontSize: 45, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
                controller: house,
                cursorColor: Colors.red,
                decoration: InputDecoration(
                  hintText: "House number",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: const BorderSide(color: Colors.red)),
                )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
                controller: phno,
                cursorColor: Colors.red,
                decoration: InputDecoration(
                  hintText: "Phone number",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: const BorderSide(color: Colors.red)),
                )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.07,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)))),
                onPressed: () {
                  // mybox.put(1,phno.text);
                  // mybox.put(2,house.text);
                  // mybox2.put(1,1);
                  FirebaseFirestore.instance
                      .collection("UserInfo")
                      .doc(user.uid)
                      .set({
                    'phone number': phno.text,
                    'house number': house.text
                  });
                  if (house.text != "" && phno.text != "") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoggedIn()));
                  } else {
                    pop(context);
                  }
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
          )
        ],
      )),
    );
  }
}
