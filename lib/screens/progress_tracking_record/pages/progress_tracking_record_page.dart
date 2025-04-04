import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:sign_and_autism/config/theme/app_colors.dart';
import 'package:sign_and_autism/screens/home/presentation/controller/home_controller.dart';

class ProgressTrackingRecordPage extends StatefulWidget {
  const ProgressTrackingRecordPage({super.key});

  @override
  State<ProgressTrackingRecordPage> createState() =>
      _ProgressTrackingRecordPageState();
}

class _ProgressTrackingRecordPageState
    extends State<ProgressTrackingRecordPage> {
  late final Box box;

  HomeController homeController = Get.find();

  @override
  void initState() {
    super.initState();
    box = Hive.box('scoreBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Progress Tracking Record",
          
          style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold, // Make it bold
        ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "${homeController.users.firstName} ${homeController.users.lastName}".toUpperCase(),
              style: TextStyle(
                fontSize: 18,

                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),
            _buildScoreCard(
                "Alphabet Knowledge Score", box.get("testAlphabetScore") ?? 0),
            _buildScoreCard(
                "Number Knowledge Score", box.get("testNumbersScore") ?? 0),
            _buildScoreCard(
                "Alphabet Time Lvl 1", box.get("testAlphabetTimeLevel1") ?? 0),
            _buildScoreCard(
                "Alphabet Time Lvl 2", box.get("testAlphabetTimeLevel2") ?? 0),
            _buildScoreCard(
                "Alphabet Time Lvl 3", box.get("testAlphabetTimeLevel3") ?? 0),
            _buildScoreCard(
                "Number Time Lvl 1", box.get("testNumberTimeLevel1") ?? 0),
            _buildScoreCard(
                "Number Time Lvl 2", box.get("testNumberTimeLevel2") ?? 0),
            _buildScoreCard(
                "Number Time Lvl 3", box.get("testNumberTimeLevel3") ?? 0),
            // _buildScoreCard(
            //     "Puzzle Easy Moves", box.get("puzzleEasyMoves") ?? 0),
            // _buildScoreCard(
            //     "Puzzle Medium Moves", box.get("puzzleMediumMoves") ?? 0),
            // _buildScoreCard(
            //     "Puzzle Hard Moves", box.get("puzzleHardMoves") ?? 0),
            // Add more score cards here as needed
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(String title, dynamic value) {
    String displayValue;
    if (title.contains("Score")) {
      displayValue = '${value ?? 0}'; // Display score, default to 0 if null
    } else if (title.contains("Time")) {
      displayValue = '${Duration(seconds: value ?? 0).toString().split('.').first}'; // Display time, default to 0:00 if null
    } else {
      displayValue = value.toString(); // Default to string representation
    }
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded( // Expanded to allow text wrapping for longer titles
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            Text(
              title.contains("Score") ? '$displayValue' : '$displayValue',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}