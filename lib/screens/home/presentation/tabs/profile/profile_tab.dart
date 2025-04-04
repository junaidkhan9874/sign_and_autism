import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_and_autism/config/theme/app_colors.dart';
import 'package:sign_and_autism/screens/home/presentation/tabs/profile/controller/profile_controller.dart';
import 'package:sign_and_autism/screens/home/presentation/tabs/profile/widgets/text_field_widget.dart';
import 'package:sign_and_autism/screens/splash/presentation/splash.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  ProfileController profileController = Get.put(ProfileController());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Gender", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value:
                                profileController.selectedGender.value == "Male"
                                    ? true
                                    : false,
                            onChanged: (val) {
                              if (val!) {
                                profileController.selectedGender.value = "Male";
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          const SizedBox(width: 10),
                          const Text("Male", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: profileController.selectedGender.value ==
                                    "Female"
                                ? true
                                : false,
                            onChanged: (val) {
                              if (val!) {
                                profileController.selectedGender.value =
                                    "Female";
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          const SizedBox(width: 10),
                          const Text("Female", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFieldWidget(
                    textEditingController:
                        profileController.firstNameController,
                    label: "Enter Child's First Name",
                  ),
                  const SizedBox(height: 20),
                  TextFieldWidget(
                      textEditingController:
                          profileController.lastNameController,
                      label: "Enter Child's Last Name"),
                  const SizedBox(height: 20),
                  TextFieldWidget(
                      textEditingController: profileController.ageController,
                      label: "Enter Child's Age"),
                  const SizedBox(height: 20),
                  TextFieldWidget(
                      textEditingController:
                          profileController.guardianNameController,
                      label: "Guardian Name"),
                  // const SizedBox(height: 20),
                  // TextFieldWidget(
                  //     textEditingController:
                  //         profileController.phoneNumberController,
                  //     label: "Phone Number"),
                  const SizedBox(height: 20),
                  TextFieldWidget(
                    textEditingController:
                        profileController.relationWithController,
                    label: "Relation with your Child",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  profileController.saveDataInFirestore();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                elevation: 0,
                fixedSize: Size(Get.width - 100, 40),
              ),
              child: Text(
                  profileController.homeController.userDataAvailable
                      ? "Update"
                      : "Save",
                  style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                Get.offAll(const SplashPage());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                elevation: 0,
                fixedSize: Size(Get.width - 100, 40),
              ),
              child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
