import 'package:flutter/material.dart';

import 'app_style.dart';

class AnswerFeedback extends StatelessWidget {
  final bool? isCorrect;
  final String message;
  const AnswerFeedback({
    super.key,
    required this.isCorrect,
    required this.message,
  });
  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: const Duration(milliseconds: 250),
    child: isCorrect == null
        ? const SizedBox(key: ValueKey('empty'), height: 88)
        : Container(
            key: ValueKey(isCorrect),
            constraints: const BoxConstraints(minHeight: 88),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppStyle.navy,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  isCorrect!
                      ? Icons.check_circle_rounded
                      : Icons.refresh_rounded,
                  color: AppStyle.yellow,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
  );
}
