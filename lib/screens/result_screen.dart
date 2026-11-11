import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../widgets/app_scaffold.dart';
import '../widgets/app_style.dart';
import '../widgets/corner_mascot.dart';

class ResultScreen extends StatelessWidget {
  final int correctAnswers, totalTasks;
  const ResultScreen({
    super.key,
    required this.correctAnswers,
    required this.totalTasks,
  });
  @override
  Widget build(BuildContext context) => AppScaffold(
    title: 'Готово!',
    child: Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppStyle.navy,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      const starSize = 100.0;
                      final mascotSize = math.min(
                        72.0,
                        (constraints.maxWidth - starSize) / 2 - 8,
                      );
                      return SizedBox(
                        width: double.infinity,
                        height: starSize,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppStyle.yellow,
                              size: starSize,
                            ),
                            if (mascotSize >= 44)
                              CornerMascot(
                                mascot: Mascot.bunny,
                                size: mascotSize,
                                side: MascotSide.left,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ты молодец!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Правильных ответов',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$correctAnswers / $totalTasks',
                    style: const TextStyle(
                      fontSize: 40,
                      color: AppStyle.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              icon: const Icon(Icons.home_rounded),
              label: const Text('Домой'),
            ),
          ],
        ),
      ),
    ),
  );
}
