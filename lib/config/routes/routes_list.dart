import 'package:get/get.dart';
import 'package:sign_and_autism/config/routes/routes_titles.dart';
import 'package:sign_and_autism/screens/auth_screen/presentation/auth.dart';
import 'package:sign_and_autism/screens/home/presentation/pages/home.dart';
import 'package:sign_and_autism/screens/login/presentation/login.dart';
import 'package:sign_and_autism/screens/sign_to_word/presentation/sign_to_word.dart';
import 'package:sign_and_autism/screens/signup/presentation/signup.dart';
import 'package:sign_and_autism/screens/splash/presentation/splash.dart';
import 'package:sign_and_autism/screens/word_to_sign/presentation/word_to_sign.dart';

class RoutesList {
  static var routes = [
    GetPage(name: RoutesTitles.splash, page: () => const SplashPage()),
    GetPage(name: RoutesTitles.auth, page: () => const Auth()),
    GetPage(name: RoutesTitles.login, page: () => const LoginPage()),
    GetPage(name: RoutesTitles.signup, page: () => const Signup()),
    GetPage(name: RoutesTitles.home, page: () => const HomePage()),
    GetPage(name: RoutesTitles.wordToSign, page: () => const WordToSignPage()),
    GetPage(name: RoutesTitles.signToWord, page: () => const SignToWordPage()),
  ];
}
