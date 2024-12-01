import 'package:flutter/material.dart';
import 'game_logic.dart';

void main() {
  runApp(WordleApp());
}

class WordleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wordle Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WordleScreen(),
    );
  }
}

class WordleScreen extends StatefulWidget {
  @override
  _WordleScreenState createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  final List<String> _words = ["LOVE", "PEACE", "FLUTTER"];
  late WordleGame _game;
  int _currentLevel = 0;
  final List<String> _guesses = [];
  String _currentGuess = "";
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startNewLevel();
  }

  void _startNewLevel() {
    if (_currentLevel < _words.length) {
      _game = WordleGame(targetWord: _words[_currentLevel]);
      _guesses.clear();
      _currentGuess = "";
      _textController.clear();
    }
  }

  void _submitGuess() {
    if (_currentGuess.length == _game.targetWord.length) {
      setState(() {
        _guesses.add(_currentGuess.toUpperCase());
        if (_currentGuess.toUpperCase() == _game.targetWord) {
          _currentLevel++;
          if (_currentLevel < _words.length) {
            _showLevelCompleteDialog();
          } else {
            _showGameCompleteDialog();
          }
        }
        _currentGuess = "";
        _textController.clear();
      });
    }
  }

  void _showLevelCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Level Complete!"),
        content: Text("You've guessed the word! Proceed to the next level."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _startNewLevel();
              });
            },
            child: Text("Next Level"),
          )
        ],
      ),
    );
  }

  void _showGameCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Congratulations!"),
        content: Text("You've completed all levels!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentLevel = 0;
                _startNewLevel();
              });
            },
            child: Text("Restart"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wordle - Level ${_currentLevel + 1}')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Display guesses and feedback
            Expanded(
              child: ListView.builder(
                itemCount: _guesses.length,
                itemBuilder: (context, index) {
                  final guess = _guesses[index];
                  final feedback = _game.checkGuess(guess);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      guess.length,
                          (i) => Container(
                        margin: EdgeInsets.all(4.0),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: feedback[i] == "correct"
                              ? Colors.green
                              : feedback[i] == "present"
                              ? Colors.yellow
                              : Colors.grey,
                          border: Border.all(),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          guess[i],
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            TextField(
              controller: _textController,
              maxLength: _game.targetWord.length,
              onChanged: (value) {
                _currentGuess = value;
              },
              onSubmitted: (value) => _submitGuess(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter your guess",
              ),
            ),
            ElevatedButton(
              onPressed: _submitGuess,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
