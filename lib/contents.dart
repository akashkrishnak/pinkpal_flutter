import 'package:companion/notifications/request_notification_permissions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class Contents extends StatefulWidget {
  const Contents({super.key});

  @override
  State<Contents> createState() => ContentsState();
}

class ContentsState extends State<Contents> {
  @override
  Widget build(BuildContext context) {
    return Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .15),
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
              "Hey there,\nWelcome to Companion",
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
                    onPressed: () async {
                      // final r = await requestNotificationPermissions(context);
                      // if (!r) {
                      //   return;
                      // }
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
        ]);
  }
}
