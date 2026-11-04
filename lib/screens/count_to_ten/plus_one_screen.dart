import 'package:flutter/material.dart';

import '../../widgets/app_scaffold.dart';
import '../../widgets/topic_card.dart';
import '../../widgets/topic_grid.dart';
import 'plus_one_task_screen.dart';

class PlusOneScreen extends StatelessWidget {
  const PlusOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '+1',
      child: TopicGrid(
        children: [
          TopicCard(
            title: '+1 в пределах 10',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlusOneTaskScreen(),
                ),
              );
            },
          ),

          TopicCard(title: 'Переместительный закон', onPressed: null),
        ],
      ),
    );
  }
}
