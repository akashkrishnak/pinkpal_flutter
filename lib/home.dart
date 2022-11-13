
import 'package:companion/houseno.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'google_sign_in.dart';
import 'package:provider/provider.dart';
import 'contents.dart';
import 'logged_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  static int? control=0;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;
  void getvalue() async {
    prefs = await _prefs;
    setState(() {
      control=prefs.containsKey("control") ? prefs.getInt("control"):0;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    getvalue();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting)
          {
            return Center(child: CircularProgressIndicator(),);
          }
          else if(snapshot.hasData)
          {
            if(control==0)
            {
              return homeno();
            }
            else{
              return logged_in();
            }
          }
          else if(snapshot.hasError)
          {
            return Center(child: Text("Something went wrong",style: TextStyle(
                    color: Color.fromARGB(255, 210, 20, 20),
                    fontSize: 35,
                    fontWeight: FontWeight.bold),),);
          }
          else
          {
            return contents();
          }
        }),
      ),
    );
  }
}