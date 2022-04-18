import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/newpremise_screen.dart';
import '../screens/home_screen.dart';

num fromRegister = 1; // variable to differentiate new user

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool exist = false;
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      print('Login page');

      Get.offAll(() => const Login_Screen());
    } else if (fromRegister == 2) {
      Get.offAll(() => const Newpremise_Screen());
    } else {
      Get.offAll(() => const Home_Screen());
    }
  }

  void register(
    String email,
    password,
  ) async {
    try {
      fromRegister = 2;
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {
        exist = result.additionalUserInfo!.isNewUser;
      });
    } catch (e) {
      Get.snackbar(
        "About User",
        "User message",
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Account creation failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void login(String email, password) async {
    try {
      fromRegister = 1;
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => exist = value.additionalUserInfo!.isNewUser);
    } catch (e) {
      Get.snackbar(
        "About Login",
        "Login message",
        snackPosition: SnackPosition.TOP,
        titleText: const Text(
          "Login failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void logOut() async {
    await auth.signOut();
  }
}
