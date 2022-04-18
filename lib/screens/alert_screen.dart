import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/firestore_controller.dart';
import 'version_screen.dart';

String storename = '';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key, required this.storename}) : super(key: key);
  final String storename;
  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  @override
  Widget build(BuildContext context) {
    storename = widget.storename;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: InkWell(
          child: const Text('Send Alert'),
          onTap: () {
            Get.to(const Version_Screen());
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
            child: Column(
          children: [
            Center(
              child: Icon(
                Icons.warning,
                size: 140,
              ),
            ),
            Text('Please tap the name below to send alert'),
            Container(
                height: MediaQuery.of(context).size.height * 0.99,
                width: MediaQuery.of(context).size.width * 0.99,
                child: AlertStream())
          ],
        )),
      )),
    );
  }
}

class AlertStream extends StatelessWidget {
  const AlertStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreController.instance.firebaseFirestore
            .collection('InOut')
            .where('isOut', isEqualTo: false)
            .where('storename', isEqualTo: storename)
            .where('isReachedLimit', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data?.docs;

            List<AlertUi> alert = [];
            for (var dat in data!) {
              final checkIn = dat.get('inTime');

              final userfullname = dat.get('userfullname');

              final historyBubble = AlertUi(
                checkin: checkIn,
                userfullname: userfullname,
              );

              alert.add(historyBubble);
            }

            return ListView(
              padding: const EdgeInsets.all(5.0),
              children: alert,
            );
          } else {
            return const Center(
              child: Text('Ooops nothing to see here'),
            );
          }
        });
  }
}

class AlertUi extends StatefulWidget {
  const AlertUi({Key? key, required this.userfullname, required this.checkin})
      : super(key: key);
  final String userfullname;
  final String checkin;
  @override
  State<AlertUi> createState() => _AlertUiState();
}

class _AlertUiState extends State<AlertUi> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    //String currentTime = DateTime(now.hour, now.minute);
    //  DateTime startTime = DateTime.parse(widget.checkin);
    String duration(String duration) {
      var dateFormat = DateFormat('HH:mm');

      String formattedTime = DateFormat.Hm().format(now);
      DateTime durationStart = dateFormat.parse(duration);
      DateTime durationEnd = dateFormat.parse(formattedTime);
      var differenceInHours = durationEnd.difference(durationStart).inHours;
      var differenceInMinutes = durationEnd.difference(durationStart).inMinutes;
      if (differenceInMinutes > 60) {
        differenceInMinutes = (differenceInMinutes % 60);
        differenceInHours += 1;
      }
      print('difference: $differenceInHours minutes');
      return '$differenceInHours hour $differenceInMinutes minutes';
    }

    ;
    return Column(
      children: [
        Container(
          width: 400,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.pink.shade100,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                widget.userfullname,
                style: const TextStyle(
                  fontSize: 20,
                  shadows: [Shadow(color: Colors.white, offset: Offset(0, 2))],
                  color: Colors.black,
                  decorationColor: Colors.black,
                  decorationThickness: 4,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: 'Check-in: ${widget.checkin} ',
                    style: const TextStyle(fontSize: 15),
                  ),
                  TextSpan(
                    text: 'Duration: ',
                    style: const TextStyle(fontSize: 15),
                  ),
                  TextSpan(
                    text: '${duration(widget.checkin)}',
                    style: TextStyle(fontSize: 15, color: Colors.red),
                  ),
                ]),
              )
            ],
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}
