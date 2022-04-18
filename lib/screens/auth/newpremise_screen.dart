import 'package:coviapremise/controller/auth_controller.dart';
import 'package:coviapremise/model/premise_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/widget.dart';
import '../../controller/firestore_controller.dart';
import '../home_screen.dart';

class Newpremise_Screen extends StatefulWidget {
  const Newpremise_Screen({Key? key}) : super(key: key);

  @override
  State<Newpremise_Screen> createState() => _Newpremise_ScreenState();
}

class _Newpremise_ScreenState extends State<Newpremise_Screen> {
  final state = [
    'Johor',
    'Kedah',
    'Kelantan',
    'Malacca',
    'Negeri Sembilan',
    'Pahang',
    'Penang',
    'Perak',
    'Perlis',
    'Sabah',
    'Sarawak',
    'Selangor',
    'Terengganu'
  ];
  String? value;
  final controllerPremisename = TextEditingController();
  final controllerPremiseAddress = TextEditingController();
  final controllerPostcode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Welcome To Covia'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: 70,
                  color: Colors.grey[900],
                ),
              ),
              InputField(
                  textCapitalization: TextCapitalization.characters,
                  inputAction: TextInputAction.next,
                  isPassword: false,
                  controller: controllerPremisename,
                  read: false,
                  label1: "Premise Name",
                  label2: ' *',
                  hint: "Premise Name",
                  inputType: TextInputType.name),
              InputField(
                  textCapitalization: TextCapitalization.none,
                  inputAction: TextInputAction.next,
                  isPassword: false,
                  controller: controllerPremiseAddress,
                  read: false,
                  label1: "Address",
                  label2: ' *',
                  hint: "Address",
                  inputType: TextInputType.name),
              InputField(
                  textCapitalization: TextCapitalization.none,
                  inputAction: TextInputAction.next,
                  isPassword: false,
                  controller: controllerPostcode,
                  read: false,
                  label1: "Postcode",
                  label2: ' *',
                  hint: "Postcode",
                  inputType: TextInputType.number),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: DropdownButton<String>(
                  value: value,
                  onChanged: ((value) => setState(() {
                        this.value = value;
                        print(value);
                      })),
                  items: state.map(buildMenuItem).toList(),
                  hint: const Text("Select state"),
                  elevation: 8,
                  isExpanded: true,
                ),
              ),
              NoIconButton(
                label: 'Register',
                onPressed: () async {
                  try {
                    final premise = Premise(
                      storename: controllerPremisename.text,
                      address: controllerPremiseAddress.text,
                      postcode: int.parse(controllerPostcode.text),
                      state: value.toString(),
                      activeuser: 0,
                      email: AuthController.instance.auth.currentUser!.email
                          .toString(),
                      crowdLimit: 0,
                      date: '',
                      durationHours: 0,
                      durationMinutes: 30,
                      durationSeconds: 0,
                      riskStatus: '',
                    );
                    await FirestoreController.instance
                        .createPremise(premise)
                        .then((value) {
                      Get.off(() => const Home_Screen());
                      Get.snackbar(
                        "Successful",
                        "",
                        snackPosition: SnackPosition.TOP,
                        titleText: const Text(
                          "Successful",
                          style: TextStyle(color: Colors.white),
                        ),
                        messageText: Text(
                          'Welcome ${controllerPremisename.text}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    });
                  } catch (e) {
                    Get.snackbar(
                      "About Registration",
                      "Fail to Save premise Data",
                      snackPosition: SnackPosition.TOP,
                      titleText: const Text(
                        "Registration failed",
                        style: TextStyle(color: Colors.white),
                      ),
                      messageText: Text(
                        e.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
}
