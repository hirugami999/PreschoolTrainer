import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preschool_trainer/main.dart';
import 'package:preschool_trainer/screens/math_screen.dart';
import 'package:preschool_trainer/screens/count_to_ten/count_to_ten_screen.dart';
import 'package:preschool_trainer/screens/count_to_ten/operation_topics_screen.dart';
import 'package:preschool_trainer/screens/count_to_ten/plus_one_screen.dart';
import 'package:preschool_trainer/screens/count_to_ten/plus_one_task_screen.dart';
import 'package:preschool_trainer/screens/count_to_ten/step_task_screen.dart';
import 'package:preschool_trainer/screens/count_to_ten/mixed_to_ten_task_screen.dart';
import 'package:preschool_trainer/screens/count_to_ten/number_composition/number_composition_screen.dart';
import 'package:preschool_trainer/screens/count_to_ten/number_composition/number_composition_mode_screen.dart';
import 'package:preschool_trainer/screens/count_to_ten/number_composition/number_composition_task_screen.dart';
import 'package:preschool_trainer/screens/result_screen.dart';
import 'package:preschool_trainer/widgets/topic_card.dart';
import 'package:preschool_trainer/widgets/answer_options.dart';

void main() {
  testWidgets('Home opens mathematics', (tester) async {
    // Ahem's wide glyphs do not match the approved home screen's real font.
    // Other screens are separately tested at text scales 1 and 2.
    tester.platformDispatcher.textScaleFactorTestValue = 0.8;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const PreschoolApp());
    await tester.tap(find.text('Математика'));
    await tester.pumpAndSettle();
    expect(find.byType(MathScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final size in [
    const Size(320, 568),
    const Size(568, 320),
    const Size(800, 1024),
  ]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('All screens fit $size at text scale $scale', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final screens = <Widget>[
          const MathScreen(),
          const CountToTenScreen(),
          const OperationTopicsScreen(isAddition: true),
          const OperationTopicsScreen(isAddition: false),
          const PlusOneScreen(),
          const PlusOneTaskScreen(),
          const NumberCompositionScreen(),
          const NumberCompositionModeScreen(number: 10),
          const StepTaskScreen(step: 1, title: '+1'),
          const StepTaskScreen(step: -10, title: '−10'),
          const MixedToTenTaskScreen(),
          const NumberCompositionTaskScreen(number: 10, isMissingNumber: false),
          const NumberCompositionTaskScreen(number: 10, isMissingNumber: true),
          const ResultScreen(correctAnswers: 7, totalTasks: 10),
        ];
        for (final screen in screens) {
          await tester.pumpWidget(
            MaterialApp(
              home: MediaQuery(
                data: MediaQueryData(
                  size: size,
                  textScaler: TextScaler.linear(scale),
                ),
                child: screen,
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(
            tester.takeException(),
            isNull,
            reason: '${screen.runtimeType}',
          );
          for (final scrollable
              in find.byType(Scrollable).evaluate().toList()) {
            final state =
                (scrollable as StatefulElement).state as ScrollableState;
            state.position.jumpTo(state.position.maxScrollExtent);
          }
          await tester.pumpAndSettle();
          expect(
            tester.takeException(),
            isNull,
            reason: '${screen.runtimeType} after scrolling',
          );
        }
      });
    }
  }

  testWidgets('Short TopicCard keeps all controls inside its bounds', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: 140,
            height: 80,
            child: TopicCard(title: 'Счёт в пределах 10', onPressed: () {}),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
  });

  testWidgets('Addition route, feedback, completion and home', (tester) async {
    // Ahem's wide glyphs do not match the approved home screen's real font.
    // Other screens are separately tested at text scales 1 and 2.
    tester.platformDispatcher.textScaleFactorTestValue = 0.8;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const PreschoolApp());
    await tester.tap(find.text('Математика'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Счёт в пределах 10'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Сложение'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('+10'), 300);
    await tester.tap(find.text('+10'));
    await tester.pumpAndSettle();
    expect(find.text('0 + 10 = ?'), findsOneWidget);
    for (var task = 1; task <= 20; task++) {
      final answer = find.descendant(
        of: find.byType(AnswerOptions),
        matching: find.text('10'),
      );
      await tester.ensureVisible(answer);
      await tester.tap(answer);
      await tester.pump();
      expect(find.text('Верно!'), findsOneWidget);
      final buttons = tester.widgetList<ElevatedButton>(
        find.descendant(
          of: find.byType(AnswerOptions),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(buttons.every((button) => button.onPressed == null), isTrue);
      await tester.pump(const Duration(milliseconds: 1200));
      await tester.pumpAndSettle();
    }
    expect(find.byType(ResultScreen), findsOneWidget);
    expect(find.text('20 / 20'), findsOneWidget);
    await tester.ensureVisible(find.text('Домой'));
    await tester.tap(find.text('Домой'));
    await tester.pumpAndSettle();
    expect(find.text('Математика'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
