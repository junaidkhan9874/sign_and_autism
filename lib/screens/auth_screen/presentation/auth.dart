import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_and_autism/config/assets/assets_config.dart';
import 'package:sign_and_autism/config/routes/routes_titles.dart';
import 'package:sign_and_autism/config/theme/app_colors.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Hero(
            tag: "logo",
            child: Image.asset(AssetsConfig.logo,
                width: Get.context!.width / 3, height: Get.context!.width / 3),
          ),
          const SizedBox(height: 40),
          Row(
            spacing: 10,
            children: [
              const SizedBox(width: 5),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(RoutesTitles.login);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.all(10),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ))),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(RoutesTitles.signup);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.all(10),
                      ),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(color: Colors.white),
                      ))),
              const SizedBox(width: 5),
            ],
          )
        ],
      ),
    );
  }
}
