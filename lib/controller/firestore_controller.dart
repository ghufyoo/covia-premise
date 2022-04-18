import 'package:coviapremise/controller/auth_controller.dart';
import 'package:coviapremise/model/premise_model.dart';
import 'package:coviapremise/model/setlimit_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreController extends GetxController {
  static FirestoreController instance = Get.find();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future createPremise(Premise premise) async {
    final docUser = firebaseFirestore
        .collection('StoreInformation')
        .doc(AuthController.instance.auth.currentUser?.email);
    final json = premise.toJson();
    await docUser.set(json);
  }

  Future setLimit(SetLimit setLimit) async {
    final docLimit = firebaseFirestore
        .collection('StoreInformation')
        .doc(setLimit.storeemail);
    final json = setLimit.toJson();
    await docLimit.update(json);
  }
}
