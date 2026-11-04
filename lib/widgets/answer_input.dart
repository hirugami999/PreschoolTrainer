import 'package:flutter/material.dart';

import 'app_style.dart';

class AnswerInput extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final int maxLength;

  const AnswerInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.maxLength = 2,
  });

  void _addDigit(String digit) {
    if (!enabled || value.length >= maxLength) {
      return;
    }

    onChanged('$value$digit');
  }

  void _deleteLast() {
    if (!enabled || value.isEmpty) {
      return;
    }

    onChanged(value.substring(0, value.length - 1));
  }

  Widget _buildKey({required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: label.length > 1 ? 20 : 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keys = <Widget>[
      ...List.generate(9, (index) {
        final digit = index + 1;

        return _buildKey(label: '$digit', onPressed: () => _addDigit('$digit'));
      }),
      _buildKey(label: 'C', onPressed: () => onChanged('')),
      _buildKey(label: '0', onPressed: () => _addDigit('0')),
      _buildKey(label: '⌫', onPressed: _deleteLast),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Поле, в котором отображается ответ.
        // Оно не вызывает системную клавиатуру.
        Container(
          height: 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppStyle.navy,
            border: Border.all(color: AppStyle.blue),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            value.isEmpty ? 'Ответ' : value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: value.isEmpty ? Colors.white70 : Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Собственная цифровая клавиатура.
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          mainAxisExtent: 64,
          children: keys,
        ),
      ],
    );
  }
}
