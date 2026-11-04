import 'package:flutter/material.dart';

class AnswerOptions extends StatelessWidget {
  final int minValue;
  final int maxValue;
  final bool enabled;
  final ValueChanged<int> onAnswerSelected;

  const AnswerOptions({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.onAnswerSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final count = maxValue - minValue + 1;

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      mainAxisExtent: 72,

      children: List.generate(count, (index) {
        final value = minValue + index;

        return ElevatedButton(
          onPressed: enabled ? () => onAnswerSelected(value) : null,

          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),

          child: Text(
            '$value',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
      }),
    );
  }
}
