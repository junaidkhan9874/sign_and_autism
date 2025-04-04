import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:sign_and_autism/config/theme/app_colors.dart';
import 'package:sign_and_autism/screens/autism_module/puzzle_screen.dart';
import 'package:sign_and_autism/screens/autism_module/test_alphabet.dart';
import 'package:sign_and_autism/screens/autism_module/test_numbers.dart';
import 'package:sign_and_autism/screens/progress_tracking_record/pages/progress_tracking_record_page.dart';

class AutismTab extends StatefulWidget {
  const AutismTab({super.key});

  @override
  State<AutismTab> createState() => _AutismTabState();
}

class _AutismTabState extends State<AutismTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(text: "Alphabet Recognition", page: AlphabetRecognition()),
            CustomButton(text: "Number Recognition", page: NumberRecognition()),
            CustomButton(text: "Puzzle-Based Learning", page: PuzzleScreen()),
            CustomButton(text: "Test Alphabet Knowledge", page: TestAlphabetScreen()),
            CustomButton(text: "Test Number Knowledge", page: TestNumbersScreen()),
            const CustomButton(text: "Progress Tracking Record", page: ProgressTrackingRecordPage()),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Widget page;

  const CustomButton({super.key, required this.text, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onPressed: () {
          Get.to(page);
        },
        child: Text(text, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class AlphabetRecognition extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts();

  AlphabetRecognition({super.key});

  void _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Alphabet Recognition",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20), // Space between AppBar and GridView
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Number of columns
                mainAxisSpacing: 12, // Increased vertical spacing
                crossAxisSpacing: 12, // Increased horizontal spacing
                childAspectRatio: 1, // Square-shaped cards
              ),
              itemCount: 26,
              itemBuilder: (context, index) {
                String letter = String.fromCharCode(65 + index);
                return GestureDetector(
                  onTap: () => _speak(letter),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0), // Added margin around each card
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90), // More rounded shape
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}

class NumberRecognition extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts();

  NumberRecognition({super.key});

  void _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Number Recognition",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40), // Adds space between AppBar and GridView
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Number of columns
                mainAxisSpacing: 24, // Vertical spacing
                crossAxisSpacing: 12, // Horizontal spacing
                childAspectRatio: 1, // Square-shaped cards
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                String number = (index + 1).toString();
                return GestureDetector(
                  onTap: () => _speak(number),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    // Small margin around each card
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90), // Makes it more rounded
                      ),
                      child: Center(
                        child: Text(
                          number,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


}

class TestAlphabetKnowledge extends StatelessWidget {
  const TestAlphabetKnowledge({super.key});

  @override
  Widget build(BuildContext context) {
    return TestModule(items: List.generate(26, (index) => String.fromCharCode(65 + index)), title: "Test Alphabet Knowledge");
  }
}

class TestNumberKnowledge extends StatelessWidget {
  const TestNumberKnowledge({super.key});

  @override
  Widget build(BuildContext context) {
    return TestModule(items: List.generate(10, (index) => (index + 1).toString()), title: "Test Number Knowledge");
  }
}

class TestModule extends StatefulWidget {
  final List<String> items;
  final String title;

  const TestModule({super.key, required this.items, required this.title});

  @override
  _TestModuleState createState() => _TestModuleState();
}

class _TestModuleState extends State<TestModule> {
  String? selectedAnswer;
  String currentQuestion = "";
  int score = 0;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    setState(() {
      currentQuestion = widget.items[Random().nextInt(widget.items.length)];
      selectedAnswer = null;
    });
  }

  void _checkAnswer(String answer) {
    if (answer == currentQuestion) {
      setState(() {
        score++;
      });
    }
    _generateQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold, // Make the title text bold
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Identify: $currentQuestion", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _checkAnswer(widget.items[index]);
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text(widget.items[index], style: TextStyle(fontSize: 20, color: Colors.white))),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          Text("Score: $score", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class PuzzleBasedLearning extends StatefulWidget {
  const PuzzleBasedLearning({super.key});

  @override
  PuzzleBasedLearningState createState() => PuzzleBasedLearningState();
}

class PuzzleBasedLearningState extends State<PuzzleBasedLearning> {
  List<String> puzzleItems = [];
  bool isSolved = false;
  int gridSize = 4;

  @override
  void initState() {
    super.initState();
    _generatePuzzle(gridSize);
  }

  void _generatePuzzle(int size) {
    setState(() {
      puzzleItems = List.generate(size * size, (index) => (index + 1).toString());
      puzzleItems.shuffle();
      isSolved = false;
    });
  }

  bool _checkSolved() {
    for (int i = 0; i < puzzleItems.length - 1; i++) {
      if (puzzleItems[i] != (i + 1).toString()) return false;
    }
    return true;
  }

  void _swapTiles(int index) {
    if (index > 0 && puzzleItems[index - 1] == '') {
      puzzleItems[index - 1] = puzzleItems[index];
      puzzleItems[index] = '';
    } else if (index < puzzleItems.length - 1 && puzzleItems[index + 1] == '') {
      puzzleItems[index + 1] = puzzleItems[index];
      puzzleItems[index] = '';
    }
    setState(() {
      if (_checkSolved()) isSolved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Puzzle-Based Learning")),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Puzzle Module")]),
    );
  }
}
