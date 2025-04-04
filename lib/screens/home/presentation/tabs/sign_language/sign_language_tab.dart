import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_and_autism/config/routes/routes_titles.dart';
import 'package:sign_and_autism/config/theme/app_colors.dart';
import 'package:sign_and_autism/screens/home/presentation/tabs/sign_language/widgets/common_sign_language.dart';

class SignLanguageTab extends StatefulWidget {
  const SignLanguageTab({super.key});

  @override
  State<SignLanguageTab> createState() => _SignLanguageTabState();
}

class _SignLanguageTabState extends State<SignLanguageTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      height: Get.height,
      width: Get.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonSignLanguage(),
            const SizedBox(height: 40),
            btnCovertWordToSign(),
            const SizedBox(height: 40),
            btnCovertSignToWord(),
          ],
        ),
      ),
    );
  }

  btnCovertWordToSign() {
    return ElevatedButton(
      onPressed: () {
        Get.toNamed(RoutesTitles.wordToSign);
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        minimumSize: Size(Get.width, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text("Convert Word to Sign", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
    );
  }

  btnCovertSignToWord() {
    return ElevatedButton(
      onPressed: () {
        Get.toNamed(RoutesTitles.signToWord);
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        minimumSize: Size(Get.width, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text("Convert Sign to Word", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
    );
  }
}
