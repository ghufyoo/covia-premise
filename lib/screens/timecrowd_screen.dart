import 'package:coviapremise/controller/firestore_controller.dart';
import 'package:coviapremise/model/setlimit_model.dart';
import 'package:coviapremise/screens/home_screen.dart';
import 'package:coviapremise/screens/version_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Timecrowd_Screen extends StatefulWidget {
  const Timecrowd_Screen(
      {Key? key, required this.storename, required this.storeemail})
      : super(key: key);
  final String storename;
  final String storeemail;
  @override
  State<Timecrowd_Screen> createState() => _Timecrowd_ScreenState();
}

class _Timecrowd_ScreenState extends State<Timecrowd_Screen> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  var hourController = TextEditingController(text: '1');
  var minuteController = TextEditingController(text: '0');
  var secondController = TextEditingController(text: '0');
  var crowdController = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: InkWell(
          child: const Text('Set Time Crowd Event'),
          onTap: () {
            Get.to(const Version_Screen());
          },
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: TableCalendar(
                rowHeight: 40,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2040, 3, 14),
                focusedDay: focusedDay,
                calendarStyle: const CalendarStyle(
                  isTodayHighlighted: true,
                  selectedDecoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                ),
                selectedDayPredicate: (DateTime date) {
                  return isSameDay(selectedDay, date);
                },
                onDaySelected: (DateTime selectDay, DateTime focusDay) {
                  setState(() {
                    selectedDay = selectDay;
                    focusedDay = focusDay;
                  });

                  print(focusedDay);
                },
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Time Limit',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(
                  width: 15,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        setTimeField(
                          hourController: hourController,
                          label: 'H',
                        ),
                        const Text(
                          'H',
                          style: TextStyle(fontSize: 25),
                        ),
                        setTimeField(
                          hourController: minuteController,
                          label: 'M',
                        ),
                        const Text(
                          'M',
                          style: TextStyle(fontSize: 25),
                        ),
                        setTimeField(
                          hourController: secondController,
                          label: 'S',
                        ),
                        const Text(
                          'S',
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
            const Text(
              'Crowd Limit',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        num intValue = int.parse(crowdController.text);
                        intValue--;
                        crowdController.text = intValue.toString();
                      });
                    },
                    icon: const Icon(Icons.remove_circle)),
                SizedBox(
                  height: 100,
                  width: 50,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: crowdController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        num intValue = int.parse(crowdController.text);
                        intValue++;
                        crowdController.text = intValue.toString();
                      });
                    },
                    icon: const Icon(Icons.add_circle)),
              ],
            ),
          ],
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 200,
        child: FloatingActionButton.extended(
          label: const Text('Set Time & Crowd Limit'),
          onPressed: () async {
            String duration = hourController.text +
                ':' +
                minuteController.text +
                ':' +
                secondController.text;
            try {
              final setLimit = SetLimit(
                  storename: widget.storename,
                  date: formattedDate,
                  durationHours: int.parse(hourController.text) ,
                  durationMinutes: int.parse(minuteController.text) ,
                  durationSeconds: int.parse(secondController.text) ,
                  crowdLimit: int.parse(crowdController.text) ,
                  storeemail: widget.storeemail);
              await FirestoreController.instance
                  .setLimit(setLimit)
                  .then((value) {
                Get.offAll(() => const Home_Screen());
                Get.snackbar(
                  "Successful",
                  "",
                  snackPosition: SnackPosition.TOP,
                  titleText: const Text(
                    "Successful",
                    style: TextStyle(color: Colors.white),
                  ),
                  messageText: Text(
                    'Date: $formattedDate Duration : $duration Crowd : ${crowdController.text}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              });
            } catch (e) {
              Get.snackbar(
                "About Set Limit",
                "Fail to Save",
                snackPosition: SnackPosition.TOP,
                titleText: const Text(
                  "Failed",
                  style: TextStyle(color: Colors.white),
                ),
                messageText: Text(
                  e.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
            print(formattedDate);
            print(hourController.text);
            print(minuteController.text);
            print(crowdController.text);
          },
        ),
      ),
    );
  }
}

class setTimeField extends StatelessWidget {
  const setTimeField(
      {Key? key, required this.hourController, required this.label})
      : super(key: key);

  final TextEditingController hourController;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        height: 60,
        width: 40,
        child: TextField(
          textAlign: TextAlign.center,
          controller: hourController,
          maxLength: 2,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            counterText: '',
            hintText: label,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
          ),
        ),
      ),
    );
  }
}
