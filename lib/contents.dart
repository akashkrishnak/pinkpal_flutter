import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class contents extends StatefulWidget {
  const contents({super.key});

  @override
  State<contents> createState() => contentsState();
}

class contentsState extends State<contents> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(
        child: Image.asset(
          'assets/icon2.png',
        ),
      ),
      Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .13),
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * .003),
        child: Text(
          "\nWelcome to\nCompanion",
          style: GoogleFonts.quicksand(
              color: Color.fromARGB(255, 20, 140, 210),
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ),
      Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogIn();
                },
                icon: FaIcon(FontAwesomeIcons.google),
                label: Text(
                  "Google Sign In",
                  style: TextStyle(fontSize: 18),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 54, 158, 244)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    )))),
          )),
      const SizedBox(
        height: 32,
      )
    ]));
  }
}
