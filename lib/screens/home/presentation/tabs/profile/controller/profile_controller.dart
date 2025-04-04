import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_and_autism/screens/home/presentation/controller/home_controller.dart';
import 'package:sign_and_autism/shared/loading_dialog.dart';

class ProfileController extends GetxController {
  RxString selectedGender = "Male".obs;

  HomeController homeController = Get.find();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController ageController;
  late TextEditingController guardianNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController relationWithController;

  saveDataInFirestore() async {
    Map<String, dynamic> data = {
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "age": ageController.text,
      "gender": selectedGender.value,
      "guardianName": guardianNameController.text,
      // "phoneNumber": phoneNumberController.text,
      "relationWith": relationWithController.text,
    };

    LoadingDialog.showLoadingDialog();

    await homeController.db.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set(data).then((va) {
      homeController.userDataAvailable = true;
    });

    Get.back();
  }

  @override
  void onInit() {
    super.onInit();

    firstNameController = TextEditingController(text: homeController.users.firstName ?? "");
    lastNameController = TextEditingController(text: homeController.users.lastName ?? "");
    ageController = TextEditingController(text: homeController.users.age ?? "");

    guardianNameController = TextEditingController(text: homeController.users.guardianName ?? "");
    // phoneNumberController = TextEditingController(text: homeController.users.phoneNumber ?? "");
    relationWithController = TextEditingController(text: homeController.users.relationWith ?? "");
    selectedGender.value = homeController.users.gender ?? "Male";
  }
}
