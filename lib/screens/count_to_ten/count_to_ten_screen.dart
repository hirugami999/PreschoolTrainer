import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/topic_card.dart';
import '../../widgets/topic_grid.dart';

import 'operation_topics_screen.dart';
import 'step_task_screen.dart';
import 'number_composition/number_composition_screen.dart';
import 'mixed_to_ten_task_screen.dart';

class CountToTenScreen extends StatelessWidget {
  const CountToTenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Счёт в пределах 10',
      child: TopicGrid(
        children: [
          // Задание +1
          TopicCard(
            title: '+1',
            icon: Icons.add_rounded,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const StepTaskScreen(step: 1, title: '+1'),
                ),
              );
            },
          ),

          // Задание -1
          TopicCard(
            title: '−1',
            icon: Icons.remove_rounded,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const StepTaskScreen(step: -1, title: '−1'),
                ),
              );
            },
          ),

          // Сложение
          TopicCard(
            title: 'Сложение',
            icon: Icons.add_circle_outline_rounded,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const OperationTopicsScreen(isAddition: true),
                ),
              );
            },
          ),

          // Вычитание
          TopicCard(
            title: 'Вычитание',
            icon: Icons.remove_circle_outline_rounded,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const OperationTopicsScreen(isAddition: false),
                ),
              );
            },
          ),

          // Смешанные задания +1 и -1
          TopicCard(
            title: '+1 и −1',
            icon: Icons.swap_horiz_rounded,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MixedToTenTaskScreen(),
                ),
              );
            },
          ),

          // Состав числа
          TopicCard(
            title: 'Состав числа',
            icon: Icons.extension_rounded,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NumberCompositionScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
