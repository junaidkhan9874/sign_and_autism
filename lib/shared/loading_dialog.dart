import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingDialog {
  static showLoadingDialog() {
    Get.defaultDialog(
      title: "",
      barrierDismissible: false,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      content: SizedBox(height: 40, width: 40, child: CircularProgressIndicator(
        color: Colors.white,
      )),
    );
  }
}
