import 'package:flutter/material.dart';
import 'puzzle_screen.dart';
import 'test_alphabet.dart';
import 'test_numbers.dart';

class AutismScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autism Learning'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PuzzleScreen()),
                );
              },
              child: Text('Puzzle Game'),
            ),
            SizedBox(height: 20), // Space between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TestAlphabetScreen()),
                );
              },
              child: Text('Alphabet Test'),
            ),
            SizedBox(height: 20), // Space between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TestNumbersScreen()),
                );
              },
              child: Text('Number Test'),
            ),
          ],
        ),
      ),
    );
  }
}
