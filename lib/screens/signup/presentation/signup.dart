import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_and_autism/config/assets/assets_config.dart';
import 'package:sign_and_autism/config/theme/app_colors.dart';
import 'package:sign_and_autism/screens/signup/controller/signup_controller.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Hero(
              tag: "logo",
              child: Image.asset(AssetsConfig.logo,
                  width: Get.context!.width / 3,
                  height: Get.context!.width / 3),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: signupController.emailController,
              decoration: const InputDecoration(
                  hintText: "Enter email", hintStyle: TextStyle(fontSize: 12)),
              style: const TextStyle(fontSize: 12),
            ),
            TextField(
              controller: signupController.passwordController,
              style: const TextStyle(fontSize: 12),
              decoration: const InputDecoration(
                  hintText: "Enter password",
                  hintStyle: TextStyle(fontSize: 12)),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  signupController.createUser();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    elevation: 0,
                    fixedSize: Size(Get.width / 1.5, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                child: const Text(
                  "Create user",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ))
          ],
        ),
      ),
    );
  }
}
