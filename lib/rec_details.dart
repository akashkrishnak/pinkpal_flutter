import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class recv_details extends StatelessWidget {
  final String name,housenumber,phone;
  const recv_details({super.key, required this.name, required this.housenumber, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red,
          title: Row(
            children: [
              Text(
                "Companion",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              )
            ],
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Name:$name',
                style: TextStyle(fontSize: 36, color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('House Number:$housenumber',
                  style: TextStyle(fontSize: 36, color: Colors.red)),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () async {
                      await FlutterPhoneDirectCaller.callNumber("$phone");
                    },
                    child: Text("call", style: TextStyle(fontSize: 40)),
                  ),
                )),
          ],
        ),
      ),
    );
    ;
  }
}
