import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preschool_trainer/screens/count_to_ten/number_composition/missing_number_examples.dart';
import 'package:preschool_trainer/screens/count_to_ten/number_composition/number_composition_examples.dart';
import 'package:preschool_trainer/screens/count_to_ten/number_composition/number_composition_task_screen.dart';
import 'package:preschool_trainer/widgets/answer_options.dart';
import 'package:preschool_trainer/widgets/exercise_layout.dart';

void main() {
  for (var number = 3; number <= 10; number++) {
    test('Composition of $number generates ten valid, varied examples', () {
      final series = <String>{};
      for (var seed = 0; seed < 30; seed++) {
        final examples = generateNumberCompositionExamples(
          number,
          Random(seed),
        );
        expect(examples, hasLength(10));
        expect(examples.where((example) => example.isAddition), hasLength(5));
        expect(examples.where((example) => !example.isAddition), hasLength(5));
        final expressions = [
          for (final example in examples)
            '${example.left}${example.symbol}${example.right}',
        ];
        series.add(expressions.join(','));
        expect(expressions.toSet(), hasLength(number == 3 ? 8 : 10));
        for (var i = 1; i < expressions.length; i++) {
          expect(expressions[i], isNot(expressions[i - 1]));
        }
        expect(
          examples.map((example) => example.answer).toSet().length,
          greaterThan(1),
        );

        for (final example in examples) {
          expect(example.left, inInclusiveRange(0, number));
          expect(example.right, inInclusiveRange(0, number));
          expect(example.answer, inInclusiveRange(0, number));
          if (example.isAddition) {
            expect(example.left + example.right, number);
          } else {
            expect(example.left, number);
          }
          expect(
            example.answer,
            example.isAddition
                ? example.left + example.right
                : example.left - example.right,
          );
        }
      }
      expect(series.length, greaterThan(1));
    });

    test('Missing number for $number uses all forms with no repeats', () {
      final series = <String>{};
      final answers = <int>{};
      for (var seed = 0; seed < 30; seed++) {
        final examples = generateMissingNumberExamples(number, Random(seed));
        expect(examples, hasLength(10));
        final expressions = examples
            .map((example) => example.expression(revealAnswer: false))
            .toList();
        expect(expressions.toSet(), hasLength(10));
        series.add(expressions.join(','));
        for (final type in MissingNumberType.values) {
          expect(
            examples.where((example) => example.type == type).length,
            inInclusiveRange(3, 4),
          );
        }
        for (var i = 0; i < examples.length; i++) {
          final answer = _solveMissingNumber(expressions[i], number);
          expect(answer, inInclusiveRange(0, number));
          expect(examples[i].answer, answer);
          expect(
            examples[i].expression(revealAnswer: true),
            expressions[i].replaceFirst('?', '$answer'),
          );
          answers.add(answer);
        }
      }
      expect(series.length, greaterThan(1));
      expect(answers, containsAll([0, number]));
    });
  }

  testWidgets('Examples accept answers from zero through N for ten tasks', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: NumberCompositionTaskScreen(number: 4, isMissingNumber: false),
      ),
    );
    final options = find.byType(AnswerOptions);
    Finder answerButton(int value) =>
        find.descendant(of: options, matching: find.text('$value'));
    for (var value = 0; value <= 4; value++) {
      expect(answerButton(value), findsOneWidget);
    }
    for (var task = 1; task <= 10; task++) {
      final layout = tester.widget<ExerciseLayout>(find.byType(ExerciseLayout));
      expect(layout.currentTask, task);
      final parts = layout.example.split(' ');
      final left = int.parse(parts[0]);
      final right = int.parse(parts[2]);
      final answer = parts[1] == '+' ? left + right : left - right;
      final button = answerButton(answer);
      await tester.ensureVisible(button);
      await tester.pump();
      await tester.tap(button);
      await tester.pump();
      expect(find.text('Верно!'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1200));
      await tester.pumpAndSettle();
    }
    expect(find.text('10 / 10'), findsOneWidget);
  });

  testWidgets('Missing number reveals the answer and completes ten tasks', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: NumberCompositionTaskScreen(number: 10, isMissingNumber: true),
      ),
    );
    final options = find.byType(AnswerOptions);
    Finder answerButton(int value) =>
        find.descendant(of: options, matching: find.text('$value'));
    for (var value = 0; value <= 10; value++) {
      expect(answerButton(value), findsOneWidget);
    }
    for (var task = 1; task <= 10; task++) {
      final layout = tester.widget<ExerciseLayout>(find.byType(ExerciseLayout));
      expect(layout.currentTask, task);
      final answer = _solveMissingNumber(layout.example, 10);
      final button = answerButton(task == 1 ? (answer + 1) % 11 : answer);
      await tester.ensureVisible(button);
      await tester.pump();
      await tester.tap(button);
      await tester.pump();
      expect(find.text(task == 1 ? 'Неверно' : 'Верно!'), findsOneWidget);
      expect(
        find.text(layout.example.replaceFirst('?', '$answer')),
        findsOneWidget,
      );
      expect(tester.widget<AnswerOptions>(options).enabled, isFalse);
      await tester.pump(const Duration(milliseconds: 1200));
      await tester.pumpAndSettle();
    }
    expect(find.text('9 / 10'), findsOneWidget);
  });
}

int _solveMissingNumber(String expression, int number) {
  final [left, operation, right, equals, result] = expression.split(' ');
  expect(equals, '=');
  if (operation == '−') {
    expect(left, '$number');
    expect(right, '?');
    return int.parse(left) - int.parse(result);
  }
  expect(operation, '+');
  expect(result, '$number');
  final known = left == '?' ? right : left;
  expect(left == '?' || right == '?', isTrue);
  return int.parse(result) - int.parse(known);
}
