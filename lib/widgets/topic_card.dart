import 'package:flutter/material.dart';

import 'app_style.dart';

class TopicCard extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final IconData? icon;
  const TopicCard({
    super.key,
    required this.title,
    required this.onPressed,
    this.icon,
  });
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: onPressed != null,
    label: onPressed == null ? '$title. Скоро' : title,
    excludeSemantics: true,
    child: Material(
      color: AppStyle.blue,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 150;
            final symbol = Icon(
              icon ?? Icons.calculate_rounded,
              size: compact ? 28 : 36,
              color: AppStyle.yellow,
            );
            final label = Text(
              onPressed == null ? '$title\nСкоро' : title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            );
            final arrow = Icon(
              onPressed == null
                  ? Icons.hourglass_empty_rounded
                  : Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 28,
            );
            return Padding(
              padding: EdgeInsets.all(compact ? 8 : 16),
              child: compact
                  ? Row(
                      children: [
                        symbol,
                        const SizedBox(width: 8),
                        Expanded(
                          child: FittedBox(fit: BoxFit.scaleDown, child: label),
                        ),
                        const SizedBox(width: 8),
                        arrow,
                      ],
                    )
                  : Column(
                      children: [
                        symbol,
                        const SizedBox(height: 8),
                        Expanded(child: Center(child: label)),
                        const SizedBox(height: 8),
                        arrow,
                      ],
                    ),
            );
          },
        ),
      ),
    ),
  );
}
