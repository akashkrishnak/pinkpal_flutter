import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class recv_details extends StatelessWidget {
  final String name, housenumber, phone;
  final String? profileUrl;
  const recv_details(
      {super.key,
      required this.name,
      required this.housenumber,
      this.profileUrl,
      required this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red,
          title: Row(
            children: const [
              Text(
                "Companion",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              )
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                profileUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 100,
                      )
                    : CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(profileUrl!)),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Emergency",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: const Text(
                        "Name :",
                        style:
                            const TextStyle(fontSize: 22, color: Colors.grey),
                      ),
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: const Text(
                        "House number :",
                        style: TextStyle(fontSize: 22, color: Colors.grey),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      housenumber,
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ))
                  ],
                ),
                // Text(
                //   'Name:$name',
                //   style: const TextStyle(fontSize: 36, color: Colors.red),
                // ),
                // Text('House Number:$housenumber',
                //     style: const TextStyle(fontSize: 36, color: Colors.red)),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10)),
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    onPressed: () async {
                      await FlutterPhoneDirectCaller.callNumber(phone);
                    },
                    child:
                        const Text("Call now", style: TextStyle(fontSize: 25)),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
