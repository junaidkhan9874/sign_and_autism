import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_and_autism/config/theme/app_colors.dart';
import 'package:sign_and_autism/screens/home/presentation/controller/home_controller.dart';
import 'package:sign_and_autism/screens/home/presentation/tabs/autism_tab/autism_tab.dart';
import 'package:sign_and_autism/screens/home/presentation/tabs/profile/profile_tab.dart';
import 'package:sign_and_autism/screens/home/presentation/tabs/sign_language/sign_language_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();

    homeController.tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(tag: "logo", child: Image.asset("assets/logo/logo.png", width: 25, height: 25)),
        centerTitle: true,
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: TabBarView(
          controller: homeController.tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [SignLanguageTab(), AutismTab(), ProfileTab()],
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        controller: homeController.tabController,
        activeColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        style: TabStyle.textIn,
        color: AppColors.primaryColor,
        initialActiveIndex: 0,
        curveSize: 100,
        onTap: (val) {
          if (val == 1 && !homeController.userDataAvailable) {
            homeController.showProfileDialog();
          }
        },
        items: [
          TabItem(
            title: 'Sign Language',
            fontFamily: 'Poppins',
            icon: Image.asset("assets/icons/sign_language.png", color: Colors.white),
          ),
          TabItem(title: 'Autism', fontFamily: 'Poppins', icon: Image.asset("assets/icons/autism.png", color: Colors.white)),
          TabItem(title: 'Profile', fontFamily: 'Poppins', icon: Image.asset("assets/icons/profile.png", color: Colors.white)),
        ],
      ),
    );
  }
}
