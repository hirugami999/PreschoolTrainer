import 'package:flutter/material.dart';

import '../widgets/app_scaffold.dart';
import '../widgets/topic_card.dart';
import '../widgets/topic_grid.dart';

import 'count_to_ten/count_to_ten_screen.dart';
import 'count_to_ten/number_composition/number_composition_screen.dart';

class MathScreen extends StatelessWidget {
  const MathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Выбери тему',

      child: TopicGrid(
        children: [
          // Счёт в пределах 10
          TopicCard(
            title: 'Счёт в пределах 10',
            icon: Icons.looks_one_rounded,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CountToTenScreen(),
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
