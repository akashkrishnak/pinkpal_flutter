import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';



class contents extends StatefulWidget {
  const contents({super.key});

  @override
  State<contents> createState() => _contentsState();
}

class _contentsState extends State<contents> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(children: [
            Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .2),
                child: Icon(
                  Icons.account_circle_outlined,
                  size: 250,
                  color: Colors.red,
                )),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .13),
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height * .07),
              child: Text(
                "Hey there,\nWelcome to Pal",
                style: GoogleFonts.quicksand(
                    color: Color.fromARGB(255, 210, 20, 20),
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 50),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        provider.googleLogIn();
                      },
                      icon: FaIcon(FontAwesomeIcons.google),
                      label: Text(
                        "Google Sign In",
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )))),
                ))
          ])
    );
  }
}