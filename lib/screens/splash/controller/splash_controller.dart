import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sign_and_autism/config/routes/routes_titles.dart';

class SplashController extends GetxController {
  timerForLoginScreen() {
    Future.delayed(const Duration(seconds: 3)).then((va) {
      if (FirebaseAuth.instance.currentUser != null) {
        Get.offNamed(RoutesTitles.home);
      } else {
        Get.offNamed(RoutesTitles.auth);
      }
    });
  }
}
