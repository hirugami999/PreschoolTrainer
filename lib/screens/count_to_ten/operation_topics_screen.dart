import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';

import '../../widgets/topic_card.dart';
import '../../widgets/topic_grid.dart';
import 'step_task_screen.dart';

class OperationTopicsScreen extends StatelessWidget {
  final bool isAddition;

  const OperationTopicsScreen({super.key, required this.isAddition});

  @override
  Widget build(BuildContext context) {
    final title = isAddition ? 'Сложение' : 'Вычитание';
    final operation = isAddition ? '+' : '−';

    return AppScaffold(
      title: title,
      child: TopicGrid(
        children: List.generate(10, (index) {
          final number = index + 1;
          final step = isAddition ? number : -number;

          return TopicCard(
            title: '$operation$number',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      StepTaskScreen(step: step, title: '$operation$number'),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
