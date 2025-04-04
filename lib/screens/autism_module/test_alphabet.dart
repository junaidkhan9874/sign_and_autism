import 'package:flutter/material.dart';
import 'dart:math';

import 'package:hive_ce/hive.dart';
import 'package:sign_and_autism/config/theme/app_colors.dart';

class TestAlphabetScreen extends StatefulWidget {
  @override
  _TestAlphabetScreenState createState() => _TestAlphabetScreenState();
}

class _TestAlphabetScreenState extends State<TestAlphabetScreen> {
  List<String> alphabets = List.generate(26, (index) => String.fromCharCode(65 + index));
  String currentLetter = '';
  int score = 0;

  @override
  void initState() {
    super.initState();
    generateRandomLetter();
  }

  void generateRandomLetter() {
    setState(() {
      currentLetter = alphabets[Random().nextInt(alphabets.length)];
    });
  }

  void checkAnswer(String letter) {
    if (letter == currentLetter) {
      setState(() {
        score++;
        final box = Hive.box('scoreBox');
        box.put("testAlphabetScore", score);
        generateRandomLetter();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alphabet Test',  style: TextStyle(fontSize: 18,
        fontWeight: FontWeight.bold,),
      ),
      centerTitle: true,
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Text(
            'Identify the Letter:',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            currentLetter,
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10), // Reduce padding for better alignment
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Prevent extra spacing
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // 5 letters per row
                  crossAxisSpacing: 12, // Add space between columns
                  mainAxisSpacing: 12, // Add space between rows
                ),
                itemCount: alphabets.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(), // Keep circular shape
                      padding: EdgeInsets.all(10), // Adjust button size
                    ),
                    onPressed: () => checkAnswer(alphabets[index]),
                    child: Text(alphabets[index], style: TextStyle(fontSize: 24)),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Score: $score',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

// Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text('Alphabet Test')),
  //     body: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text('Identify the Letter:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
  //         Text(currentLetter, style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.blue)),
  //         GridView.builder(
  //           shrinkWrap: true,
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
  //           itemCount: alphabets.length,
  //           itemBuilder: (context, index) {
  //             return ElevatedButton(
  //               onPressed: () => checkAnswer(alphabets[index]),
  //               child: Text(alphabets[index], style: TextStyle(fontSize: 24)),
  //             );
  //           },
  //         ),
  //         SizedBox(height: 20),
  //         Text('Score: $score', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
  //       ],
  //     ),
  //   );
  // }
}
