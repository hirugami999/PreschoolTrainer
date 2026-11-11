import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'app_style.dart';

class AnswerFeedback extends StatefulWidget {
  final bool? isCorrect;
  final String message;
  const AnswerFeedback({
    super.key,
    required this.isCorrect,
    required this.message,
  });

  @override
  State<AnswerFeedback> createState() => _AnswerFeedbackState();
}

class _AnswerFeedbackState extends State<AnswerFeedback> {
  @override
  void didUpdateWidget(covariant AnswerFeedback oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCorrect == null && widget.isCorrect != null) {
      WidgetsBinding.instance.addPostFrameCallback(_revealFeedback);
    }
  }

  void _revealFeedback(Duration _) {
    if (!mounted ||
        widget.isCorrect == null ||
        ModalRoute.of(context)?.isCurrent != true) {
      return;
    }

    final position = Scrollable.maybeOf(context)?.position;
    final target = context.findRenderObject();
    if (position == null || target == null || !target.attached) return;
    final viewport = RenderAbstractViewport.maybeOf(target);
    if (viewport == null) return;

    final top = viewport.getOffsetToReveal(target, 0).offset;
    final bottom = viewport.getOffsetToReveal(target, 1).offset;
    final offset = position.pixels;
    if (offset <= top && offset >= bottom) return;

    position.ensureVisible(
      target,
      alignment: offset > top || bottom > top ? 0 : 1,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCorrect = widget.isCorrect;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: isCorrect == null
          ? const SizedBox(key: ValueKey('empty'), height: 88)
          : Container(
              key: ValueKey(isCorrect),
              constraints: const BoxConstraints(minHeight: 88),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppStyle.navy,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    isCorrect
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    color: isCorrect ? Colors.greenAccent : Colors.redAccent,
                    size: 40,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
