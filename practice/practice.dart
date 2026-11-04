import 'dart:developer' as developer;

void main() {
  int answer = 4;
  int userAnswer = 5;

  bool isCorrect = userAnswer == answer;

  developer.log(isCorrect.toString());
}
