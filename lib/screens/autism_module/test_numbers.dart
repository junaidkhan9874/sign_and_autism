import 'package:flutter/material.dart';
import 'dart:math';

import 'package:hive_ce/hive.dart';
import 'package:sign_and_autism/config/theme/app_colors.dart';

class TestNumbersScreen extends StatefulWidget {
  @override
  _TestNumbersScreenState createState() => _TestNumbersScreenState();
}

class _TestNumbersScreenState extends State<TestNumbersScreen> {
  List<String> numbers = List.generate(20, (index) => (index + 1).toString());
  String currentNumber = '';
  int score = 0;

  @override
  void initState() {
    super.initState();
    generateRandomNumber();
  }

  void generateRandomNumber() {
    setState(() {
      currentNumber = numbers[Random().nextInt(numbers.length)];
    });
  }

  void checkAnswer(String number) {
    if (number == currentNumber) {
      setState(() {
        score++;
        final box = Hive.box('scoreBox');
        box.put("testNumbersScore", score);
        generateRandomNumber();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Number Test' , style: TextStyle(fontSize: 18,
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
            'Identify the Number:',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            currentNumber,
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10), // Reduce padding
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Prevent extra spacing
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 5 numbers per row
                  crossAxisSpacing: 12, // Reduce spacing between numbers
                  mainAxisSpacing: 12, // Reduce vertical spacing
                ),
                itemCount: numbers.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(), // Keep circular shape
                      padding: EdgeInsets.all(12), // Adjust button size
                    ),
                    onPressed: () => checkAnswer(numbers[index]),
                    child: Text(numbers[index], style: TextStyle(fontSize: 28)),
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


}
