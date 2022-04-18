import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/firestore_controller.dart';
import 'version_screen.dart';

String storename = '';

class CrowdHistoryScreen extends StatefulWidget {
  const CrowdHistoryScreen({Key? key, required this.storename})
      : super(key: key);

  final String storename;
  @override
  State<CrowdHistoryScreen> createState() => _CrowdHistoryScreenState();
}

class _CrowdHistoryScreenState extends State<CrowdHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    storename = widget.storename;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: InkWell(
          child: const Text('History'),
          onTap: () {
            Get.to(const Version_Screen());
          },
        ),
      ),
      body: const HistoryStream(),
    );
  }
}

class HistoryStream extends StatelessWidget {
  const HistoryStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreController.instance.firebaseFirestore
            .collection('InOut')
            .where('isOut', isEqualTo: true)
            .where('storename', isEqualTo: storename)
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

            List<HistoryUi> history = [];
            for (var dat in data!) {
              final date = dat.get('date');
              final storename = dat.get('storename');
              final checkIn = dat.get('inTime');
              final checkOut = dat.get('outTime');
              final duration = dat.get('duration');
              final riskstatus = dat.get('riskstatus');
              final userfullname = dat.get('userfullname');

              final historyBubble = HistoryUi(
                date: date,
                storename: storename,
                checkin: checkIn,
                checkout: checkOut,
                duration: duration,
                riskstatus: riskstatus,
                userfullname: userfullname,
              );

              history.add(historyBubble);
            }

            return ListView(
              padding: const EdgeInsets.all(5.0),
              children: history,
            );
          } else {
            return const Center(
              child: Text('Ooops nothing to see here'),
            );
          }
        });
  }
}

class HistoryUi extends StatefulWidget {
  const HistoryUi(
      {Key? key,
      required this.date,
      required this.storename,
      required this.checkin,
      required this.checkout,
      required this.duration,
      required this.riskstatus,
      required this.userfullname})
      : super(key: key);

  final String date;
  final String storename;
  final String checkin;
  final String checkout;
  final String duration;
  final String riskstatus;
  final String userfullname;

  @override
  State<HistoryUi> createState() => _HistoryUiState();
}

class _HistoryUiState extends State<HistoryUi> {
  @override
  Widget build(BuildContext context) {
    Color color(String riskstatus) {
      Color col;
      if (riskstatus == 'Low Risk') {
        col = Colors.green;
        return col;
      } else if (riskstatus == 'Moderate') {
        col = Colors.yellow;
        return col;
      } else {
        col = Colors.red;
        return col;
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(widget.date),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 8,
          decoration: BoxDecoration(
            color: color(widget.riskstatus),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.userfullname,
                style: const TextStyle(
                  fontSize: 30,
                  shadows: [Shadow(color: Colors.black, offset: Offset(0, -5))],
                  color: Colors.transparent,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.black,
                  decorationThickness: 4,
                  decorationStyle: TextDecorationStyle.dashed,
                ),
              ),
              Text(
                'Check-in: ${widget.checkin}, Duration: ${widget.duration}',
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
