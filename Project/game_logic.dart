class WordleGame {
  final String targetWord;
  static const int maxGuesses = 6;

  WordleGame({required this.targetWord});


  List<String> checkGuess(String guess) {
    List<String> feedback = List.filled(targetWord.length, "absent");
    for (int i = 0; i < targetWord.length; i++) {
      if (guess[i] == targetWord[i]) {
        feedback[i] = "correct";
      } else if (targetWord.contains(guess[i])) {
        feedback[i] = "present";
      }
    }
    return feedback;
   }
}
