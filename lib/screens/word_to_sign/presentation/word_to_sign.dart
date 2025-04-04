import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sign_and_autism/config/theme/app_colors.dart';

class WordToSignPage extends StatefulWidget {
  const WordToSignPage({super.key});

  @override
  State<WordToSignPage> createState() => _WordToSignPageState();
}

class _WordToSignPageState extends State<WordToSignPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        title: Text("Convert Word to Sign", style: TextStyle(fontSize: 16, color: Colors.white)),
        centerTitle: true,
      ),
    );
  }
}
