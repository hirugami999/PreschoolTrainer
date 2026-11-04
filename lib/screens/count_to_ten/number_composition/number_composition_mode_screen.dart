import 'package:flutter/material.dart';

import '../../../widgets/app_scaffold.dart';

import '../../../widgets/topic_card.dart';
import '../../../widgets/topic_grid.dart';
import 'number_composition_task_screen.dart';

// Для каждого числа два вида упражнений.
class NumberCompositionModeScreen extends StatelessWidget {
  final int number;

  const NumberCompositionModeScreen({super.key, required this.number})
    : assert(number >= 3 && number <= 10);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Состав числа $number',
      child: TopicGrid(
        children: [
          TopicCard(
            title: 'Примеры',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NumberCompositionTaskScreen(
                    number: number,
                    isMissingNumber: false,
                  ),
                ),
              );
            },
          ),
          TopicCard(
            title: 'Число пропало',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NumberCompositionTaskScreen(
                    number: number,
                    isMissingNumber: true,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
