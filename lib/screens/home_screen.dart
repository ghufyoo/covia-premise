import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coviapremise/controller/auth_controller.dart';
import 'package:coviapremise/screens/alert_screen.dart';
import 'package:coviapremise/screens/history_screen.dart';
import 'package:coviapremise/screens/qrcode_screen.dart';
import 'package:coviapremise/screens/timecrowd_screen.dart';
import 'package:coviapremise/screens/version_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/widget.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({Key? key}) : super(key: key);

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  TimeOfDay day = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: InkWell(
            child: const Text('CovIA For Premises'),
            onTap: () {
              print(day.period);
              Get.to(const Version_Screen());
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  AuthController.instance.auth.signOut();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('StoreInformation')
                .doc(AuthController.instance.auth.currentUser?.email.toString())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('Something Went Wrong! ${snapshot.error}');
              }
              final data = snapshot.data!;

              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Text(
                          '${data['storename']}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 45),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconBtn(
                              color1: Colors.green,
                              color2: Colors.green[100]!,
                              onPressed: () {
                                Get.to(() => Timecrowd_Screen(
                                      storeemail: data['email'].toString(),
                                      storename: data['storename'],
                                    ));
                              },
                              icon: Icons.groups,
                              label: 'Time & Crowd\nLimit'),
                          IconBtn(
                              color1: Colors.blue,
                              color2: Colors.blue[100]!,
                              onPressed: () {
                                Get.to(() => CrowdHistoryScreen(
                                      storename: data['storename'].toString(),
                                    ));
                              },
                              icon: Icons.history,
                              label: 'Crowd History'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconBtn(
                              color1: Colors.pink,
                              color2: Colors.pink[100]!,
                              onPressed: () {
                                Get.to(Qrcode_Screen(
                                  storeemail: data['email'],
                                  storename: data['storename'],
                                ));
                              },
                              icon: Icons.person,
                              label: 'Qr Code'),
                          IconBtn(
                              color1: Colors.red,
                              color2: Colors.red[100]!,
                              onPressed: () {
                                Get.to(() => AlertScreen(
                                      storename: data['storename'],
                                    ));
                              },
                              icon: Icons.priority_high,
                              label: 'Send Alert'),
                        ],
                      ),
                    ]),
              );
            }));
  }
}
