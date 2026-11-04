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

    if (widget.step > 0) {
      // Для +2: первое число от 0 до 8, сумма не больше 10.
      firstNumber = random.nextInt(11 - amount);
    } else {
      // Для -2: первое число от 2 до 10, разность не меньше 0.
      firstNumber = random.nextInt(11 - amount) + amount;
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
      if (!mounted) return;
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
