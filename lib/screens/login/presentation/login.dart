import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_and_autism/config/theme/app_colors.dart';
import 'package:sign_and_autism/screens/login/controller/login_controller.dart';

import '../../../config/assets/assets_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController loginController = Get.put(LoginController());

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
            const SizedBox(height: 40),
            Hero(
              tag: "logo",
              child: Image.asset(AssetsConfig.logo,
                  width: Get.context!.width / 3,
                  height: Get.context!.width / 3),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                loginController.signInToGoogle();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.all(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/icons/google.png",
                      width: 25, color: Colors.white),
                  const SizedBox(width: 20),
                  const Text("Sign In with Google",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showEmailPasswordDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.all(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/icons/google.png",
                      width: 25, color: Colors.white),
                  const SizedBox(width: 20),
                  const Text("Login with email",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showEmailPasswordDialog() {
    Get.defaultDialog(
        title: "Enter your credentials",
        titleStyle: const TextStyle(fontSize: 14),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: loginController.emailController,
              keyboardType: TextInputType.emailAddress, // Sets input type to email
              decoration: const InputDecoration(
                  hintText: "Enter email", hintStyle: TextStyle(fontSize: 12)),
              style: const TextStyle(fontSize: 12),
            ),
            TextField(
              controller: loginController.passwordController,
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
                  loginController.signInUsingEmailPassword();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor, elevation: 0),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ))
          ],
        ));
  }
}
