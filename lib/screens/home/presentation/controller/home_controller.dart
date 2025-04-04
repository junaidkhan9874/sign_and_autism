import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_and_autism/screens/home/model/users.dart';
import 'package:sign_and_autism/shared/loading_dialog.dart';

class HomeController extends GetxController {
  var db = FirebaseFirestore.instance;
  late TabController tabController;

  bool userDataAvailable = false;

  Users users = Users();

  checkUserProfileData() async {
    LoadingDialog.showLoadingDialog();
    await db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        userDataAvailable = true;
        users = Users.fromJson(value.data() ?? {});
      } else {
        userDataAvailable = false;
      }
    });
    Get.back();
  }

  void showProfileDialog() {
    Get.defaultDialog(
      title: "",
      barrierDismissible: false,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      onWillPop: () async {
        return false;
      },
      content: Container(
        width: Get.width / 1.5,
        height: Get.width / 1.5,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "You need to add your child's information first",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back();
                tabController.animateTo(2);
              },
              style: ElevatedButton.styleFrom(elevation: 0),
              child: const Text("Go to Profile"),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   checkUserProfileData();
  // }

  @override
  void onReady() {
    checkUserProfileData();
  }
}
