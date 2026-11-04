import 'package:flutter/material.dart';

import 'app_scaffold.dart';
import 'app_style.dart';
import 'answer_feedback.dart';
import 'answer_options.dart';

class ExerciseLayout extends StatelessWidget {
  final String title, example, feedbackMessage;
  final int currentTask, totalTasks, minValue, maxValue;
  final bool? feedbackIsCorrect;
  final bool enabled;
  final ValueChanged<int> onAnswerSelected;
  final int? correctAnswers;
  const ExerciseLayout({
    super.key,
    required this.title,
    required this.example,
    required this.currentTask,
    required this.totalTasks,
    required this.feedbackIsCorrect,
    required this.feedbackMessage,
    required this.minValue,
    required this.maxValue,
    required this.enabled,
    required this.onAnswerSelected,
    this.correctAnswers,
  });
  @override
  Widget build(BuildContext context) => AppScaffold(
    title: title,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Задание $currentTask из $totalTasks',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: currentTask / totalTasks,
              minHeight: 10,
              color: AppStyle.yellow,
              backgroundColor: AppStyle.navy,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: AppStyle.navy,
              borderRadius: BorderRadius.circular(24),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                example,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnswerFeedback(
            isCorrect: feedbackIsCorrect,
            message: feedbackMessage,
          ),
          const SizedBox(height: 16),
          AnswerOptions(
            minValue: minValue,
            maxValue: maxValue,
            enabled: enabled,
            onAnswerSelected: onAnswerSelected,
          ),
          if (correctAnswers != null) ...[
            const SizedBox(height: 20),
            Text(
              'Правильных ответов: $correctAnswers',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ],
      ),
    ),
  );
}
