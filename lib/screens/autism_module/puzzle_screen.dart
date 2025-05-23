import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_ce/hive.dart';
import 'package:sign_and_autism/config/theme/app_colors.dart';
import 'package:vibration/vibration.dart';


class PuzzlePiece {
  final String id;
  final Widget child;
  final String targetId;
  bool isPlaced;

  PuzzlePiece({
    required this.id,
    required this.child,
    required this.targetId,
    this.isPlaced = false,
  });
}

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzlePieceGameScreenState();
}

class _PuzzlePieceGameScreenState extends State<PuzzleScreen> {
  bool isAlphabet = true;
  int currentLevel = 1;
  late List<PuzzlePiece> pieces;
  late Map<String, bool> targetsFilled;
  bool puzzleComplete = false;
  String feedbackMessage = "Drag the pieces to the matching spots!";
  int gridSize = 3;
  int secondsElapsed = 0;
  Timer? timer;
  bool isSelectionScreen = true;

  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _initializeLevel();
  }

  @override
  void dispose() {
    timer?.cancel();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  void _initializeLevel() {
    setState(() {
      puzzleComplete = false;
      feedbackMessage = "Drag the pieces to the matching spots!";
      gridSize = currentLevel == 1 ? 2 : (currentLevel == 2 ? 3 : 4);

      if (isAlphabet) {
        _initializeAlphabetLevel();
      } else {
        _initializeNumberLevel();
      }

      pieces.forEach((piece) => piece.isPlaced = false);
      targetsFilled.forEach((key, value) => targetsFilled[key] = false);
      secondsElapsed = 0;
      timer?.cancel();
      _startTimer();
    });
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  void _initializeAlphabetLevel() {
    List<String> alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    List<String> selectedLetters = [];
    Random random = Random();
    int pieceCount = gridSize * gridSize;

    while (selectedLetters.length < pieceCount) {
      String letter = alphabet[random.nextInt(alphabet.length)];
      if (!selectedLetters.contains(letter)) {
        selectedLetters.add(letter);
      }
    }

    pieces = selectedLetters
        .map((letter) => PuzzlePiece(
      id: 'piece$letter',
      child: Text(letter, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
      targetId: 'target_$letter',
    ))
        .toList();

    targetsFilled = Map.fromIterable(selectedLetters, key: (v) => 'target_$v', value: (v) => false);
  }

  void _initializeNumberLevel() {
    List<int> numbers = List.generate(26, (index) => index + 1);
    List<int> selectedNumbers = [];
    Random random = Random();
    int pieceCount = gridSize * gridSize;

    while (selectedNumbers.length < pieceCount) {
      int number = numbers[random.nextInt(numbers.length)];
      if (!selectedNumbers.contains(number)) {
        selectedNumbers.add(number);
      }
    }

    pieces = selectedNumbers
        .map((number) => PuzzlePiece(
      id: 'piece$number',
      child: Text('$number', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
      targetId: 'target_$number',
    ))
        .toList();

    targetsFilled = Map.fromIterable(selectedNumbers, key: (v) => 'target_$v', value: (v) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Puzzle Based Learning',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        actions: isSelectionScreen
            ? null
            : [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Restart Timer',
            onPressed: () {
              setState(() {
                if (puzzleComplete) {
                  _initializeLevel(); // Restart level with shuffled pieces if puzzle is complete
                } else {
                  secondsElapsed = 0;
                  timer?.cancel();
                  _startTimer();
                }// Reset timer only
              });
            },
          ),
        ],
      ),
      body: isSelectionScreen ? buildSelectionScreen() : buildPuzzleScreen(),
    );
  }

  Widget buildSelectionScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                isAlphabet = true;
                isSelectionScreen = false;
                currentLevel = 1;
                _initializeLevel();
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
            ),
            child: const Text('Alphabet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isAlphabet = false;
                isSelectionScreen = false;
                currentLevel = 1;
                _initializeLevel();
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
            ),
            child: const Text('Numbers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget buildPuzzleScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Time: ${Duration(seconds: secondsElapsed).toString().split('.').first}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    ...targetsFilled.keys.map((targetId) {
                      final index = targetsFilled.keys.toList().indexOf(targetId);
                      final row = index ~/ gridSize;
                      final col = index % gridSize;
                      final top = 50.0 + row * 80.0;
                      final left = (MediaQuery.of(context).size.width / 2) - (gridSize * 33) + col * 75;
                      return Positioned(
                        top: top,
                        left: left,
                        child: buildDragTarget(targetId, Colors.grey.withOpacity(0.3)),
                      );
                    })
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: pieces
                        .where((piece) => !piece.isPlaced)
                        .map((piece) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: buildDraggablePiece(piece),
                    ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            feedbackMessage,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: puzzleComplete ? Colors.green : Colors.black,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildLevelButton(1),
            const SizedBox(width: 20),
            buildLevelButton(2),
            const SizedBox(width: 20),
            buildLevelButton(3),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildLevelButton(int level) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          currentLevel = level;
          _initializeLevel();
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
      child: Text('Level $level'),
    );
  }

  Widget buildDraggablePiece(PuzzlePiece piece) {
    return Draggable<PuzzlePiece>(
      data: piece,
      feedback: GestureDetector(
        onTap: () => _speak((piece.child as Text).data ?? ''),
        child: Opacity(opacity: 0.7, child: piece.child),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: SizedBox(width: 50, height: 50, child: piece.child)),
      child: GestureDetector(
        onTap: () => _speak((piece.child as Text).data ?? ''),
        child: Container(
          width: 55,
          height: 50,
          decoration: BoxDecoration(border: Border.all(color: Colors.amber)),
          child: Center(
            child: piece.child is Text
                ? Text(
              (piece.child as Text).data!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            )
                : piece.child,
          ),
        ),
      ),
    );
  }

  Widget buildDragTarget(String targetId, Color targetColor) {
    bool isFilled = targetsFilled[targetId] ?? false;

    return DragTarget<PuzzlePiece>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isFilled ? Colors.green.withOpacity(0.3) : targetColor,
            border: Border.all(color: Colors.amber),
          ),
          child: Center(
            child: isFilled
                ? const Icon(Icons.check_circle, color: Colors.white, size: 30)
                : Text(targetId.split("_")[1], style: const TextStyle(fontSize: 30)),
          ),
        );
      },
      onWillAcceptWithDetails: (details) {
        return !isFilled && details.data.targetId == targetId;
      },
      onAcceptWithDetails: (details) {
        setState(() {
          PuzzlePiece acceptedPiece = details.data;
          acceptedPiece.isPlaced = true;
          targetsFilled[targetId] = true;
          feedbackMessage = "Piece placed!";
          _speak((acceptedPiece.child as Text).data ?? '');

          if (targetsFilled.values.every((filled) => filled)) {
            puzzleComplete = true;
            _speak(feedbackMessage = "Puzzle Complete!");
            timer?.cancel();
            _saveTimeToHive();
          }
        });
      },
      onLeave: (data) {
        // Trigger vibration on wrong match
        if (data?.targetId != targetId) {
          _speak("Wrong");// Vibrate on wrong match
        }
      },
    );
  }

  void _saveTimeToHive() async {
    final timeBox = Hive.box('scoreBox');
    if (isAlphabet) {
      timeBox.put("testAlphabetTimeLevel$currentLevel", secondsElapsed);
    } else {
      timeBox.put("testNumberTimeLevel$currentLevel", secondsElapsed);
    }
  }
}




// import 'dart:async'; // Import Timer
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:hive_ce/hive.dart'; // Import Hive
// import 'package:sign_and_autism/config/theme/app_colors.dart';
//
// class PuzzlePiece {
//   final String id;
//   final Widget child;
//   final String targetId;
//   bool isPlaced;
//
//   PuzzlePiece({
//     required this.id,
//     required this.child,
//     required this.targetId,
//     this.isPlaced = false,
//   });
// }
//
// class PuzzleScreen extends StatefulWidget {
//   const PuzzleScreen({super.key});
//
//   @override
//   State<PuzzleScreen> createState() => _PuzzlePieceGameScreenState();
// }
//
// class _PuzzlePieceGameScreenState extends State<PuzzleScreen> {
//   bool isAlphabet = true;
//   int currentLevel = 1;
//   late List<PuzzlePiece> pieces;
//   late Map<String, bool> targetsFilled;
//   bool puzzleComplete = false;
//   String feedbackMessage = "Drag the pieces to the matching spots!";
//   int gridSize = 3;
//   int secondsElapsed = 0; // Track elapsed time
//   Timer? timer; // Timer instance
//
//   bool isSelectionScreen = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeLevel();
//   }
//
//   @override
//   void dispose() {
//     if (timer != null && timer!.isActive) {
//       timer!.cancel();
//     }
//     super.dispose();
//   }
//
//   void _initializeLevel() {
//     setState(() {
//       puzzleComplete = false;
//       feedbackMessage = "Drag the pieces to the matching spots!";
//       gridSize = currentLevel == 1 ? 2 : (currentLevel == 2 ? 3 : 4);
//
//       if (isAlphabet) {
//         _initializeAlphabetLevel();
//       } else {
//         _initializeNumberLevel();
//       }
//
//       pieces.forEach((piece) => piece.isPlaced = false);
//       targetsFilled.forEach((key, value) => targetsFilled[key] = false);
//       secondsElapsed = 0; // Reset time
//       timer?.cancel(); // Cancel any existing timer
//       _startTimer(); // Start a new timer
//     });
//   }
//
//   void _startTimer() {
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         secondsElapsed++;
//       });
//     });
//   }
//
//   void _initializeAlphabetLevel() {
//     List<String> alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
//     List<String> selectedLetters = [];
//     Random random = Random();
//     int pieceCount = gridSize * gridSize;
//
//     while (selectedLetters.length < pieceCount) {
//       String letter = alphabet[random.nextInt(alphabet.length)];
//       if (!selectedLetters.contains(letter)) {
//         selectedLetters.add(letter);
//       }
//     }
//
//     pieces = selectedLetters
//         .map((letter) => PuzzlePiece(
//               id: 'piece$letter',
//               child: Text(letter, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
//               targetId: 'target_$letter',
//             ))
//         .toList();
//
//     targetsFilled = Map.fromIterable(selectedLetters, key: (v) => 'target_$v', value: (v) => false);
//   }
//
//   void _initializeNumberLevel() {
//     List<int> numbers = List.generate(26, (index) => index + 1);
//     List<int> selectedNumbers = [];
//     Random random = Random();
//     int pieceCount = gridSize * gridSize;
//
//     while (selectedNumbers.length < pieceCount) {
//       int number = numbers[random.nextInt(numbers.length)];
//       if (!selectedNumbers.contains(number)) {
//         selectedNumbers.add(number);
//       }
//     }
//
//     pieces = selectedNumbers
//         .map((number) => PuzzlePiece(
//               id: 'piece$number',
//               child: Text('$number', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
//               targetId: 'target_$number',
//             ))
//         .toList();
//
//     targetsFilled = Map.fromIterable(selectedNumbers, key: (v) => 'target_$v', value: (v) => false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // title: Text('${isAlphabet ? 'Alphabet' : 'Number'} - Level $currentLevel'),
//         title: const Text(
//           'Puzzle Based Learning',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold, // Make it bold
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: AppColors.primaryColor,
//         foregroundColor: Colors.white,
//         actions: isSelectionScreen
//             ? null
//             : [
//           IconButton(
//             icon: const Icon(Icons.restart_alt),
//             tooltip: 'Restart Timer',
//             onPressed: () {
//               setState(() {
//                 secondsElapsed = 0;
//                 timer?.cancel();
//                 _startTimer();
//               });
//             },
//           ),
//         ],
//       ),
//
//       body: isSelectionScreen ? buildSelectionScreen() : buildPuzzleScreen(),
//     );
//   }
//
//   Widget buildSelectionScreen() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   isAlphabet = true;
//                   isSelectionScreen = false;
//                   currentLevel = 1;
//                   _initializeLevel();
//                 });
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//                 textStyle: const TextStyle(fontSize: 20),
//                 backgroundColor: Colors.amber,
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text(
//                 'Alphabet',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               )),
//           const SizedBox(height: 20),
//           ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   isAlphabet = false;
//                   isSelectionScreen = false;
//                   currentLevel = 1;
//                   _initializeLevel();
//                 });
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//                 textStyle: const TextStyle(fontSize: 20),
//                 backgroundColor: Colors.amber,
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text(
//                 'Numbers',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
//
//   Widget buildPuzzleScreen() {
//     return Column(
//
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: Text(
//             'Time: ${Duration(seconds: secondsElapsed).toString().split('.').first}', // Format time
//             style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//         ),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Expanded(
//                 child: Stack(
//                   children: [
//                     ...targetsFilled.keys.map((targetId) {
//                       final index = targetsFilled.keys.toList().indexOf(targetId);
//                       final row = index ~/ gridSize;
//                       final col = index % gridSize;
//                       final top = 80.0 + row * 80.0;
//                       final left = (MediaQuery.of(context).size.width / 2) - (gridSize * 35) + col * 75;
//                       return Positioned(
//                         top: top,
//                         left: left,
//                         child: buildDragTarget(targetId, Colors.grey.withOpacity(0.3)),
//                       );
//                     })
//                   ],
//                 ),
//               ),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: pieces
//                         .where((piece) => !piece.isPlaced)
//                         .map((piece) => Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 8),
//                               child: buildDraggablePiece(piece),
//                             ))
//                         .toList(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: Text(
//             feedbackMessage,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: puzzleComplete ? Colors.green : Colors.black,
//             ),
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             buildLevelButton(1),
//             const SizedBox(width: 20),
//             buildLevelButton(2),
//             const SizedBox(width: 20),
//             buildLevelButton(3),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget buildLevelButton(int level) {
//     return ElevatedButton(
//       onPressed: () {
//         setState(() {
//           currentLevel = level;
//           _initializeLevel();
//         });
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.amber,
//         foregroundColor: Colors.black,
//       ),
//       child: Text('Level $level'),
//     );
//   }
//
//   Widget buildDraggablePiece(PuzzlePiece piece) {
//     return Draggable<PuzzlePiece>(
//       data: piece,
//       feedback: Opacity(opacity: 0.7, child: piece.child),
//       childWhenDragging: Opacity(opacity: 0.3, child: SizedBox(width: 50, height: 50, child: piece.child)),
//       child: Container(
//         width: 55,
//         height: 50,
//         decoration: BoxDecoration(border: Border.all(color: Colors.amber)),
//         child: Center(
//           child: piece.child is Text
//               ? Text(
//             (piece.child as Text).data!,
//             textAlign: TextAlign.center, // Center text inside the container
//             style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), // Adjust font size if needed
//           )
//               : piece.child,
//         ),
//
//       ),    );
//   }
//
//   Widget buildDragTarget(String targetId, Color targetColor) {
//     bool isFilled = targetsFilled[targetId] ?? false;
//
//     return DragTarget<PuzzlePiece>(
//       builder: (context, candidateData, rejectedData) {
//         return Container(
//           width: 50,
//           height: 50,
//           decoration: BoxDecoration(
//               color: isFilled ? Colors.green.withOpacity(0.3) : targetColor, border: Border.all(color: Colors.amber)),
//           child: Center(
//             child: isFilled
//                 ? const Icon(Icons.check_circle, color: Colors.white, size: 30)
//                 : Text(targetId.split("_")[1], style: const TextStyle(fontSize: 30)),
//           ),
//         );
//       },
//       onWillAcceptWithDetails: (details) {
//         return !isFilled && details.data.targetId == targetId;
//       },
//       onAcceptWithDetails: (details) {
//         setState(() {
//           PuzzlePiece acceptedPiece = details.data;
//           acceptedPiece.isPlaced = true;
//           targetsFilled[targetId] = true;
//           feedbackMessage = "Piece placed!";
//
//           if (targetsFilled.values.every((filled) => filled)) {
//             puzzleComplete = true;
//             feedbackMessage = "Puzzle Complete!";
//             timer?.cancel(); // Stop timer when puzzle is complete
//             _saveTimeToHive(); // Save the time
//           }
//         });
//       },
//     );
//   }
//
//   void _saveTimeToHive() async {
//     final timeBox = Hive.box('scoreBox'); // Use your Hive box name
//     if (isAlphabet) {
//       timeBox.put("testAlphabetTimeLevel$currentLevel", secondsElapsed);
//       print(timeBox);
//     } else {
//       timeBox.put("testNumberTimeLevel$currentLevel", secondsElapsed);
//     }
//   }
// }
