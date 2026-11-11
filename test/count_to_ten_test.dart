import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preschool_trainer/screens/count_to_ten/mixed_to_ten_task_screen.dart';
import 'package:preschool_trainer/screens/count_to_ten/operation_topics_screen.dart';
import 'package:preschool_trainer/screens/count_to_ten/plus_one_task_screen.dart';
import 'package:preschool_trainer/screens/count_to_ten/step_task_screen.dart';
import 'package:preschool_trainer/widgets/answer_options.dart';
import 'package:preschool_trainer/widgets/exercise_layout.dart';
import 'package:preschool_trainer/widgets/topic_card.dart';
import 'package:preschool_trainer/widgets/topic_grid.dart';

void main() {
  for (final isAddition in [true, false]) {
    final symbol = isAddition ? '+' : '−';
    testWidgets('Operation menu offers only ${symbol}1 through ${symbol}9', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: OperationTopicsScreen(isAddition: isAddition)),
      );
      final grid = tester.widget<TopicGrid>(find.byType(TopicGrid));
      expect(
        grid.children.cast<TopicCard>().map((card) => card.title),
        List.generate(9, (index) => '$symbol${index + 1}'),
      );
    });

    for (var amount = 1; amount <= 9; amount++) {
      final step = isAddition ? amount : -amount;
      final title = '$symbol$amount';
      testWidgets('$title offers valid answers and completes its series', (
        tester,
      ) async {
        await _completeSeries(
          tester,
          StepTaskScreen(step: step, title: title),
          allowedSteps: {step},
          distinctNeighbors: amount > 2,
        );
      });
    }
  }

  testWidgets('Mixed +1 and −1 completes with valid answers', (tester) async {
    await _completeSeries(
      tester,
      const MixedToTenTaskScreen(),
      allowedSteps: {1, -1},
    );
  });

  testWidgets('Legacy +1 completes with valid answers', (tester) async {
    await _completeSeries(tester, const PlusOneTaskScreen(), allowedSteps: {1});
  });
}

Future<void> _completeSeries(
  WidgetTester tester,
  Widget screen, {
  required Set<int> allowedSteps,
  bool distinctNeighbors = false,
}) async {
  await tester.pumpWidget(MaterialApp(home: screen));
  String? previous;
  for (var task = 1; task <= 20; task++) {
    final layout = tester.widget<ExerciseLayout>(find.byType(ExerciseLayout));
    expect(layout.currentTask, task);
    expect(layout.totalTasks, 20);
    final [left, symbol, right, equals, missing] = layout.example.split(' ');
    expect(symbol, anyOf('+', '−'));
    expect(equals, '=');
    expect(missing, '?');
    final first = int.parse(left);
    final amount = int.parse(right);
    final step = symbol == '+' ? amount : -amount;
    final answer = first + step;
    expect(first, inInclusiveRange(0, 10));
    expect(allowedSteps, contains(step));
    expect(answer, inInclusiveRange(0, 10));
    if (distinctNeighbors) expect(layout.example, isNot(previous));
    previous = layout.example;

    final button = find.descendant(
      of: find.byType(AnswerOptions),
      matching: find.text('$answer'),
    );
    expect(button, findsOneWidget);
    await tester.ensureVisible(button);
    await tester.pump();
    await tester.tap(button);
    await tester.pump();
    expect(find.text('Верно!'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();
  }
  expect(find.text('20 / 20'), findsOneWidget);
}
