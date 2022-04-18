import 'package:coviapremise/screens/auth/register_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/widget.dart';
import '../../controller/auth_controller.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({Key? key}) : super(key: key);

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    color: Colors.blue,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'CovIA',
                          style: TextStyle(color: Colors.white, fontSize: 70),
                        ),
                        Text(
                          'Premises Version',
                          style: TextStyle(color: Colors.white30, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 40, bottom: 20),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(color: Colors.black, fontSize: 50),
                    ),
                  ),
                  InputField(
                    textCapitalization: TextCapitalization.none,
                    isPassword: false,
                    controller: emailController,
                    label1: 'Email',
                    label2: '',
                    hint: 'Enter Your Premises Email',
                    inputType: TextInputType.emailAddress,
                    read: false,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  InputField(
                    textCapitalization: TextCapitalization.none,
                    isPassword: true,
                    controller: passwordController,
                    label1: 'Password',
                    label2: '',
                    hint: 'Enter Your Premises Password',
                    inputType: TextInputType.text,
                    read: false,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RoundedButton(
                      label: 'Login',
                      icon: Icons.login,
                      onPressed: () {
                        AuthController.instance.login(
                            emailController.text.trim(),
                            passwordController.text.trim());
                      }),
                  const SizedBox(
                    height: 25,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'New?',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' Register First',
                              style: const TextStyle(
                                  color: Colors.blueAccent, fontSize: 18),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(() => const Registration_Screen());
                                }),
                          // TextSpan(
                          //   text: ' Or Sync With MySejahtera',
                          //   style: TextStyle(color: Colors.black, fontSize: 18),
                          // ),
                        ]),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     Get.to(Mysejahtera_Screen());
                  //   },
                  //   child: SizedBox(
                  //     width: 100,
                  //     height: 100,
                  //     child: Image.asset('assets/MySejahtera_logo.png'),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
