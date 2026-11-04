import 'dart:math';

import 'package:flutter/material.dart';

import '../../../widgets/exercise_layout.dart';
import '../../result_screen.dart';

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

  static const int _totalTasks = 10;
  int _currentTask = 1;
  int _correctAnswers = 0;

  int _firstPart = 1;
  bool _missingOnLeft = false;
  bool _hasPreviousTask = false;

  bool _isAnswered = false;
  bool? _feedbackIsCorrect;
  String _feedbackMessage = '';

  // В обычных примерах ответ равен выбранному числу.
  // В «Число пропало» нужно найти второе слагаемое.
  int get _correctAnswer =>
      widget.isMissingNumber ? widget.number - _firstPart : widget.number;

  @override
  void initState() {
    super.initState();
    _generateTask();
  }

  void _generateTask() {
    int nextFirstPart;
    bool nextMissingOnLeft;

    // Не показываем два одинаковых примера подряд.
    do {
      nextFirstPart = _random.nextInt(widget.number - 1) + 1;
      nextMissingOnLeft = widget.isMissingNumber && _random.nextBool();
    } while (_hasPreviousTask &&
        nextFirstPart == _firstPart &&
        nextMissingOnLeft == _missingOnLeft);

    _firstPart = nextFirstPart;
    _missingOnLeft = nextMissingOnLeft;
    _hasPreviousTask = true;
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
      if (!mounted) return;
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
      _generateTask();
      _isAnswered = false;
      _feedbackIsCorrect = null;
      _feedbackMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final int secondPart = widget.number - _firstPart;
    final String displayedAnswer = _isAnswered ? '$_correctAnswer' : '?';

    final String example;
    if (!widget.isMissingNumber) {
      // Обычные примеры: 2 + 3 = ?
      example = '$_firstPart + $secondPart = $displayedAnswer';
    } else if (_missingOnLeft) {
      // Число пропало слева: ? + 2 = 5
      example = '$displayedAnswer + $_firstPart = ${widget.number}';
    } else {
      // Число пропало справа: 2 + ? = 5
      example = '$_firstPart + $displayedAnswer = ${widget.number}';
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
      minValue: 1,
      maxValue: widget.isMissingNumber ? widget.number - 1 : widget.number,
      enabled: !_isAnswered,
      onAnswerSelected: _checkAnswer,
    );
  }
}
