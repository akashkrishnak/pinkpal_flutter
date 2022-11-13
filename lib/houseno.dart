import 'package:companion/home.dart';
import 'package:companion/logged_in.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homeno extends StatefulWidget {
  const homeno({super.key});

  @override
  State<homeno> createState() => homenoState();
}
void pop(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Alert',style: GoogleFonts.quicksand(color: Colors.red, fontSize: 25,fontWeight:FontWeight.bold),),
            content: SizedBox(
              height: 80,
              child: Center(
                child:Text('Enter the details',style: GoogleFonts.quicksand(color: Colors.red, fontSize: 20),),
              ),
            ));
      },
    );
  }
class homenoState extends State<homeno> {
  TextEditingController house = TextEditingController();
  TextEditingController phno = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences prefs;
  void test() async
  {
    prefs=await _prefs;
  }
  @override
  void initState() {
    // TODO: implement initState
    test();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
                    "Enter house number & phone number",
                    style: GoogleFonts.quicksand(
                        color: Colors.red,
                        fontSize: 45,
                        fontWeight: FontWeight.bold),
                  ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
                controller: house,
                cursorColor: Colors.red,
                decoration: InputDecoration(
                  hintText: "House number",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.red, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.red)),
                )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
                controller: phno,
                cursorColor: Colors.red,
                decoration: InputDecoration(
                  hintText: "Phone number",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.red)),
                )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
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
                  prefs.setString("house",house.text);
                  prefs.setString("phone",phno.text);
                  prefs.setInt("control", 1);
                  if(house.text!="" && phno.text!="")
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>logged_in()));
                  }
                  else
                  {
                    pop(context);
                  }
                },
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
          )
        ],
      )),
    );
  }
}
