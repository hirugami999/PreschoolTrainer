import 'dart:math' as math;

import 'package:flutter/material.dart';

class TopicGrid extends StatelessWidget {
  final List<Widget> children;
  const TopicGrid({super.key, required this.children});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scale = MediaQuery.textScalerOf(context).scale(20) / 20;
      return GridView.count(
        padding: const EdgeInsets.only(bottom: 12),
        crossAxisCount: constraints.maxWidth >= 320 * math.max(1, scale)
            ? 2
            : 1,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        mainAxisExtent: 210 + 80 * math.max(0, scale - 1),
        children: children,
      );
    },
  );
}
