import 'dart:math';

import 'package:flutter/material.dart';

import '../../widgets/exercise_layout.dart';
import '../result_screen.dart';

class StepTaskScreen extends StatefulWidget {
  final int step;
  final String title;

  const StepTaskScreen({super.key, required this.step, required this.title})
    : assert(step != 0 && step >= -10 && step <= 10);

  @override
  State<StepTaskScreen> createState() => _StepTaskScreenState();
}

class _StepTaskScreenState extends State<StepTaskScreen> {
  final Random random = Random();

  int firstNumber = 0;
  int currentTask = 1;
  final int totalTasks = 20;
  int correctAnswers = 0;

  bool isAnswered = false;
  bool? feedbackIsCorrect;
  String feedbackMessage = '';

  int get correctAnswer => firstNumber + widget.step;

  @override
  void initState() {
    super.initState();
    generateTask();
  }

  void generateTask() {
    final amount = widget.step.abs();
    final minimum = widget.step > 0 ? 0 : amount;
    final choices = 11 - amount;
    if (currentTask > 1 && amount > 2 && choices > 1) {
      // Pick an index from the range with the previous operand removed.
      final candidate = minimum + random.nextInt(choices - 1);
      firstNumber = candidate < firstNumber ? candidate : candidate + 1;
    } else {
      firstNumber = minimum + random.nextInt(choices);
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
    final operation = widget.step > 0 ? '+' : '−';
    final amount = widget.step.abs();
    final displayedAnswer = isAnswered ? '$correctAnswer' : '?';

    return ExerciseLayout(
      title: widget.title,
      example: '$firstNumber $operation $amount = $displayedAnswer',
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
