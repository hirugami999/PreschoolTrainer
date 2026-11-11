import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preschool_trainer/screens/count_to_ten/mixed_to_ten_task_screen.dart';
import 'package:preschool_trainer/screens/count_to_ten/number_composition/number_composition_task_screen.dart';
import 'package:preschool_trainer/screens/count_to_ten/step_task_screen.dart';
import 'package:preschool_trainer/screens/result_screen.dart';
import 'package:preschool_trainer/widgets/answer_feedback.dart';
import 'package:preschool_trainer/widgets/answer_options.dart';
import 'package:preschool_trainer/widgets/exercise_layout.dart';

void main() {
  const cases = [
    (
      size: Size(568, 320),
      screen: StepTaskScreen(step: 9, title: '+9'),
      correct: true,
      needsScroll: true,
    ),
    (
      size: Size(320, 568),
      screen: NumberCompositionTaskScreen(number: 10, isMissingNumber: false),
      correct: false,
      needsScroll: false,
    ),
    (
      size: Size(393, 852),
      screen: MixedToTenTaskScreen(),
      correct: true,
      needsScroll: false,
    ),
  ];

  for (final scenario in cases) {
    testWidgets('Feedback is visible at ${scenario.size}', (tester) async {
      _setScreenSize(tester, scenario.size);
      await tester.pumpWidget(MaterialApp(home: scenario.screen));
      final position = await _scrollToBottom(tester);
      final initialOffset = position.pixels;
      expect(_feedbackIsVisible(tester), !scenario.needsScroll);

      await _tapAnswer(tester, correct: scenario.correct, repeat: true);
      await tester.pump();
      expect(position.isScrollingNotifier.value, scenario.needsScroll);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 110));
      if (scenario.needsScroll) {
        expect(position.pixels, lessThan(initialOffset));
        expect(position.isScrollingNotifier.value, isTrue);
      }
      await tester.pump(const Duration(milliseconds: 140));

      expect(_feedbackIsVisible(tester), isTrue);
      expect(
        find.text(scenario.correct ? 'Верно!' : 'Неверно'),
        findsOneWidget,
      );
      final icon = tester.widget<Icon>(
        find.byIcon(
          scenario.correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
        ),
      );
      expect(
        icon.color,
        scenario.correct ? Colors.greenAccent : Colors.redAccent,
      );
      if (!scenario.needsScroll) {
        // Revealing the answer can change the equation height and scroll limit.
        expect(
          position.pixels,
          initialOffset.clamp(
            position.minScrollExtent,
            position.maxScrollExtent,
          ),
        );
      }

      await tester.pump(const Duration(milliseconds: 949));
      expect(_layout(tester).currentTask, 1);
      await tester.pump(const Duration(milliseconds: 1));
      expect(_layout(tester).currentTask, 2);
      await tester.pumpAndSettle();
    });
  }

  testWidgets('Leaving during the feedback scroll is safe', (tester) async {
    _setScreenSize(tester, const Size(568, 320));
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (_) => const StepTaskScreen(step: 9, title: '+9'),
                ),
              ),
              child: const Text('Темы'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Темы'));
    await tester.pumpAndSettle();
    final position = await _scrollToBottom(tester);
    await _tapAnswer(tester, correct: true);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 70));
    expect(position.isScrollingNotifier.value, isTrue);

    await tester.tap(find.byTooltip('Назад'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 1200));
    expect(find.text('Темы'), findsOneWidget);
    expect(find.byType(ExerciseLayout), findsNothing);
    expect(find.byType(ResultScreen), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

void _setScreenSize(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

ExerciseLayout _layout(WidgetTester tester) =>
    tester.widget<ExerciseLayout>(find.byType(ExerciseLayout));

Future<ScrollPosition> _scrollToBottom(WidgetTester tester) async {
  final position = tester
      .state<ScrollableState>(find.byType(Scrollable).first)
      .position;
  position.jumpTo(position.maxScrollExtent);
  await tester.pump();
  return position;
}

bool _feedbackIsVisible(WidgetTester tester) {
  final feedback = tester.getRect(find.byType(AnswerFeedback));
  final viewport = tester.getRect(find.byType(CustomScrollView));
  return feedback.top >= viewport.top - 0.01 &&
      feedback.bottom <= viewport.bottom + 0.01;
}

Future<void> _tapAnswer(
  WidgetTester tester, {
  required bool correct,
  bool repeat = false,
}) async {
  final layout = _layout(tester);
  final [left, operation, right, _, _] = layout.example.split(' ');
  final first = int.parse(left);
  final second = int.parse(right);
  final answer = operation == '+' ? first + second : first - second;
  final selected = correct
      ? answer
      : (answer == layout.maxValue ? answer - 1 : layout.maxValue);
  final button = find.descendant(
    of: find.byType(AnswerOptions),
    matching: find.text('$selected'),
  );
  await tester.tap(button);
  if (repeat) await tester.tap(button);
}
