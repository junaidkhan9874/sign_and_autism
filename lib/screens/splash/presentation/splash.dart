import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_and_autism/config/assets/assets_config.dart';
import 'package:sign_and_autism/config/text_strings/text_strings.dart';
import 'package:sign_and_autism/screens/splash/controller/splash_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SplashController splashController = Get.put(SplashController());

  @override
  void initState() {
    super.initState();

    splashController.timerForLoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: "logo",
              child: Image.asset(AssetsConfig.logo, width: Get.context!.width / 2, height: Get.context!.width / 2),
            ),
            const SizedBox(height: 20),
            Text(TextStrings.appName, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
