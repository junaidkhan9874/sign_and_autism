import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_and_autism/config/routes/routes_titles.dart';

class LoginController extends GetxController {
  late GoogleSignInAccount? googleSignIn;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  goToHomeScreen() {
    Get.offNamed(RoutesTitles.home);
  }

  signInToGoogle() async {
    try {
      googleSignIn = await GoogleSignIn(scopes: ["email"]).signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleSignIn?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);

      goToHomeScreen();
    } catch (e) {
      Get.showSnackbar(GetSnackBar(message: e.toString()));
    }
  }

  signInUsingEmailPassword() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) {
      Get.toNamed(RoutesTitles.home);
    });
  }
}
