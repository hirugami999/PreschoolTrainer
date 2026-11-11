import 'dart:math';

import 'package:flutter/material.dart';

import '../../widgets/exercise_layout.dart';
import '../result_screen.dart';

class PlusOneTaskScreen extends StatefulWidget {
  const PlusOneTaskScreen({super.key});

  @override
  State<PlusOneTaskScreen> createState() => _PlusOneTaskScreenState();
}

class _PlusOneTaskScreenState extends State<PlusOneTaskScreen> {
  int number = Random().nextInt(10);

  int currentTask = 1;
  final int totalTasks = 20;
  int correctAnswers = 0;

  bool isAnswered = false;

  bool? feedbackIsCorrect;
  String feedbackMessage = '';

  // Вызывается сразу при нажатии на число.
  void selectAnswer(int userAnswer) {
    if (isAnswered) {
      return;
    }

    final correctAnswer = number + 1;
    final isCorrect = userAnswer == correctAnswer;

    setState(() {
      isAnswered = true;
      feedbackIsCorrect = isCorrect;

      if (isCorrect) {
        correctAnswers++;
        feedbackMessage = 'Верно!';
      } else {
        feedbackMessage = 'Неверно! Ответ: $correctAnswer';
      }
    });

    // Показываем реакцию и автоматически продолжаем.
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
      nextTask();
    });
  }

  void nextTask() {
    if (currentTask < totalTasks) {
      setState(() {
        currentTask++;
        number = Random().nextInt(10);

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
    final displayedAnswer = isAnswered ? '${number + 1}' : '?';
    return ExerciseLayout(
      title: '+1 в пределах 10',
      example: '$number + 1 = $displayedAnswer',
      currentTask: currentTask,
      totalTasks: totalTasks,
      feedbackIsCorrect: feedbackIsCorrect,
      feedbackMessage: feedbackMessage,
      minValue: 1,
      maxValue: 10,
      enabled: !isAnswered,
      onAnswerSelected: selectAnswer,
      correctAnswers: correctAnswers,
    );
  }
}
