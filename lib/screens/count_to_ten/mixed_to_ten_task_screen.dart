import 'dart:math';

import 'package:flutter/material.dart';

import '../../widgets/exercise_layout.dart';
import '../result_screen.dart';

class MixedToTenTaskScreen extends StatefulWidget {
  const MixedToTenTaskScreen({super.key});

  @override
  State<MixedToTenTaskScreen> createState() => _MixedToTenTaskScreenState();
}

class _MixedToTenTaskScreenState extends State<MixedToTenTaskScreen> {
  final Random random = Random();

  int firstNumber = 1;
  bool isAddition = true;
  int currentTask = 1;
  final int totalTasks = 20;
  int correctAnswers = 0;

  bool isAnswered = false;
  bool? feedbackIsCorrect;
  String feedbackMessage = '';

  int get correctAnswer => firstNumber + (isAddition ? 1 : -1);

  @override
  void initState() {
    super.initState();
    generateTask();
  }

  void generateTask() {
    isAddition = random.nextBool();
    if (isAddition) {
      // 1 + 1 ... 9 + 1
      firstNumber = random.nextInt(9) + 1;
    } else {
      // 1 - 1 ... 10 - 1
      firstNumber = random.nextInt(10) + 1;
    }
  }

  void selectAnswer(int userAnswer) {
    if (isAnswered) return;

    final isCorrect = userAnswer == correctAnswer;

    setState(() {
      isAnswered = true;
      feedbackIsCorrect = isCorrect;
      if (isCorrect) {
        correctAnswers++;
      }
      feedbackMessage = isCorrect ? 'Верно!' : 'Неверно';
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
      nextTask();
    });
  }

  void nextTask() {
    if (currentTask < totalTasks) {
      setState(() {
        currentTask++;
        generateTask();
        isAnswered = false;
        feedbackIsCorrect = null;
        feedbackMessage = '';
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            correctAnswers: correctAnswers,
            totalTasks: totalTasks,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final operation = isAddition ? '+' : '−';
    final displayedAnswer = isAnswered ? '$correctAnswer' : '?';

    return ExerciseLayout(
      title: '+1 и −1',
      example: '$firstNumber $operation 1 = $displayedAnswer',
      currentTask: currentTask,
      totalTasks: totalTasks,
      feedbackIsCorrect: feedbackIsCorrect,
      feedbackMessage: feedbackMessage,
      minValue: 0,
      maxValue: 10,
      enabled: !isAnswered,
      onAnswerSelected: selectAnswer,
    );
  }
}
