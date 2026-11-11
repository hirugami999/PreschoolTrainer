import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preschool_trainer/screens/count_to_ten/mixed_to_ten_task_screen.dart';
import 'package:preschool_trainer/screens/count_to_ten/number_composition/number_composition_task_screen.dart';
import 'package:preschool_trainer/screens/count_to_ten/plus_one_task_screen.dart';
import 'package:preschool_trainer/screens/count_to_ten/step_task_screen.dart';
import 'package:preschool_trainer/screens/result_screen.dart';
import 'package:preschool_trainer/widgets/answer_options.dart';
import 'package:preschool_trainer/widgets/exercise_layout.dart';

const _delay = Duration(milliseconds: 1200);
const _last50Milliseconds = Duration(milliseconds: 50);

void main() {
  const exercises = <String, Widget>{
    'Step': StepTaskScreen(step: 1, title: '+1'),
    'Mixed': MixedToTenTaskScreen(),
    'Composition examples': NumberCompositionTaskScreen(
      number: 4,
      isMissingNumber: false,
    ),
    'Missing number': NumberCompositionTaskScreen(
      number: 4,
      isMissingNumber: true,
    ),
    'Plus one': PlusOneTaskScreen(),
  };

  for (final entry in exercises.entries) {
    testWidgets('${entry.key} opens one result after rapid answer taps', (
      tester,
    ) async {
      final observer = await _openExercise(tester, entry.value);
      await _reachFinalTask(tester);
      final layout = _exerciseLayout(tester);
      final answer = find.descendant(
        of: find.byType(AnswerOptions),
        matching: find.text('${layout.minValue}'),
      );
      await tester.tap(answer);
      await tester.tap(answer);
      await tester.tap(answer);
      await tester.pump();

      await tester.pump(_delay - _last50Milliseconds);
      expect(find.byType(ResultScreen), findsNothing);
      await tester.pump(_last50Milliseconds);
      await tester.pumpAndSettle();

      expect(find.byType(ResultScreen), findsOneWidget);
      expect(observer.replacements, 1);
      expect(
        tester.widget<ResultScreen>(find.byType(ResultScreen)).totalTasks,
        layout.totalTasks,
      );
      await tester.tap(find.byTooltip('Назад'));
      await tester.pumpAndSettle();
      expect(find.text('Темы'), findsOneWidget);
      expect(find.byType(ExerciseLayout), findsNothing);
    });

    testWidgets('${entry.key} cancels the result when leaving at 1150 ms', (
      tester,
    ) async {
      final observer = await _openExercise(tester, entry.value);
      await _reachFinalTask(tester);
      await _answerAndLeaveJustBeforeTransition(tester);
      await tester.pumpAndSettle();

      expect(find.text('Темы'), findsOneWidget);
      expect(find.byType(ResultScreen, skipOffstage: false), findsNothing);
      expect(observer.replacements, 0);
    });

    testWidgets('${entry.key} does not advance while its route is popping', (
      tester,
    ) async {
      final observer = await _openExercise(tester, entry.value);
      await _answerAndLeaveJustBeforeTransition(tester);

      // The outgoing route is still mounted during its reverse animation.
      final outgoing = find.byType(ExerciseLayout, skipOffstage: false);
      expect(outgoing, findsOneWidget);
      expect(tester.widget<ExerciseLayout>(outgoing).currentTask, 1);
      await tester.pumpAndSettle();
      expect(find.text('Темы'), findsOneWidget);
      expect(find.byType(ExerciseLayout, skipOffstage: false), findsNothing);
      expect(observer.replacements, 0);
    });
  }
}

class _ReplacementObserver extends NavigatorObserver {
  int replacements = 0;

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    replacements++;
  }
}

Future<_ReplacementObserver> _openExercise(
  WidgetTester tester,
  Widget exercise,
) async {
  final observer = _ReplacementObserver();
  await tester.pumpWidget(
    MaterialApp(
      navigatorObservers: [observer],
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => Navigator.push<void>(
              context,
              MaterialPageRoute(builder: (context) => exercise),
            ),
            child: const Text('Темы'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Темы'));
  await tester.pumpAndSettle();
  return observer;
}

ExerciseLayout _exerciseLayout(WidgetTester tester) =>
    tester.widget<ExerciseLayout>(find.byType(ExerciseLayout));

Future<void> _reachFinalTask(WidgetTester tester) async {
  final total = _exerciseLayout(tester).totalTasks;
  for (var task = 1; task < total; task++) {
    final layout = _exerciseLayout(tester);
    expect(layout.currentTask, task);
    layout.onAnswerSelected(layout.minValue);
    await tester.pump(_delay);
  }
  expect(_exerciseLayout(tester).currentTask, total);
}

Future<void> _answerAndLeaveJustBeforeTransition(WidgetTester tester) async {
  final layout = _exerciseLayout(tester);
  layout.onAnswerSelected(layout.minValue);
  await tester.pump();
  await tester.pump(_delay - _last50Milliseconds);
  await tester.tap(find.byTooltip('Назад'));
  await tester.pump();
  await tester.pump(_last50Milliseconds);
}
