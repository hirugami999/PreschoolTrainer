import 'package:flutter/material.dart';

import '../../../widgets/topic_card.dart';
import '../../../widgets/topic_grid.dart';
import 'number_composition_mode_screen.dart';
import '../../../widgets/app_scaffold.dart';

// Выбор числа: от 3 до 10.
class NumberCompositionScreen extends StatelessWidget {
  const NumberCompositionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Состав числа',
      child: TopicGrid(
        children: List.generate(8, (index) {
          final int number = index + 3;

          return TopicCard(
            title: '$number',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NumberCompositionModeScreen(number: number),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
