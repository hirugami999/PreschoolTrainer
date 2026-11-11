import 'dart:math';

import 'package:flutter/material.dart';

import '../../../widgets/exercise_layout.dart';
import '../../result_screen.dart';
import 'missing_number_examples.dart';
import 'number_composition_examples.dart';

// Универсальный экран для обычных примеров и «Число пропало».
class NumberCompositionTaskScreen extends StatefulWidget {
  final int number;
  final bool isMissingNumber;

  const NumberCompositionTaskScreen({
    super.key,
    required this.number,
    required this.isMissingNumber,
  }) : assert(number >= 3 && number <= 10);

  @override
  State<NumberCompositionTaskScreen> createState() =>
      _NumberCompositionTaskScreenState();
}

class _NumberCompositionTaskScreenState
    extends State<NumberCompositionTaskScreen> {
  final Random _random = Random();

  static const int _totalTasks = numberCompositionTaskCount;
  int _currentTask = 1;
  int _correctAnswers = 0;

  late final List<NumberCompositionExample> _examples;
  NumberCompositionExample get _currentExample => _examples[_currentTask - 1];

  late final List<MissingNumberExample> _missingExamples =
      generateMissingNumberExamples(widget.number, _random);
  MissingNumberExample get _currentMissingExample =>
      _missingExamples[_currentTask - 1];

  bool _isAnswered = false;
  bool? _feedbackIsCorrect;
  String _feedbackMessage = '';

  int get _correctAnswer => widget.isMissingNumber
      ? _currentMissingExample.answer
      : _currentExample.answer;

  @override
  void initState() {
    super.initState();
    if (!widget.isMissingNumber) {
      _examples = generateNumberCompositionExamples(widget.number, _random);
    }
  }

  void _checkAnswer(int answer) {
    if (_isAnswered) return;

    final bool isCorrect = answer == _correctAnswer;

    setState(() {
      _isAnswered = true;
      _feedbackIsCorrect = isCorrect;
      _feedbackMessage = isCorrect ? 'Верно!' : 'Неверно';

      if (isCorrect) {
        _correctAnswers++;
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
      _nextTask();
    });
  }

  void _nextTask() {
    if (_currentTask == _totalTasks) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            correctAnswers: _correctAnswers,
            totalTasks: _totalTasks,
          ),
        ),
      );
      return;
    }

    setState(() {
      _currentTask++;
      _isAnswered = false;
      _feedbackIsCorrect = null;
      _feedbackMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final String example;
    if (widget.isMissingNumber) {
      example = _currentMissingExample.expression(revealAnswer: _isAnswered);
    } else {
      final task = _currentExample;
      final displayedAnswer = _isAnswered ? '${task.answer}' : '?';
      example = '${task.left} ${task.symbol} ${task.right} = $displayedAnswer';
    }

    return ExerciseLayout(
      title: widget.isMissingNumber
          ? 'Число пропало: ${widget.number}'
          : 'Примеры: ${widget.number}',
      example: example,
      currentTask: _currentTask,
      totalTasks: _totalTasks,
      feedbackIsCorrect: _feedbackIsCorrect,
      feedbackMessage: _feedbackMessage,
      minValue: 0,
      maxValue: widget.number,
      enabled: !_isAnswered,
      onAnswerSelected: _checkAnswer,
    );
  }
}
