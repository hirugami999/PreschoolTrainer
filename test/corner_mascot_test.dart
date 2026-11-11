import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preschool_trainer/screens/math_screen.dart';
import 'package:preschool_trainer/screens/result_screen.dart';
import 'package:preschool_trainer/widgets/answer_options.dart';
import 'package:preschool_trainer/widgets/corner_mascot.dart';
import 'package:preschool_trainer/widgets/exercise_layout.dart';
import 'package:preschool_trainer/widgets/topic_card.dart';

void main() {
  testWidgets('Topic mascots sit below the cards inside the safe area', (
    tester,
  ) async {
    await _showScreen(tester, const Size(390, 840), const MathScreen());
    final mascots = find.byType(CornerMascot);
    expect(mascots, findsNWidgets(2));
    final lastCard = tester.getRect(find.byType(TopicCard).last);
    expect(tester.widget<CornerMascot>(mascots.first).mascot, Mascot.fox);
    expect(tester.widget<CornerMascot>(mascots.last).mascot, Mascot.bunny);
    final fox = tester.getRect(mascots.first);
    final bunny = tester.getRect(mascots.last);
    expect(fox.center.dx + bunny.center.dx, closeTo(390, 0.01));
    expect(fox.height * 721 / 1536, closeTo(bunny.height * 782 / 818, 0.01));
    expect(
      fox.bottom - fox.height * 457 / 1536,
      closeTo(bunny.bottom - bunny.height * 18 / 818, 0.01),
    );
    for (final bounds in [fox, bunny]) {
      expect(bounds.top, greaterThan(lastCard.bottom));
      expect(bounds.bottom, lessThanOrEqualTo(840 - 28));
    }
    await tester.tap(find.text('Состав числа'));
    await tester.pumpAndSettle();
    expect(find.text('3'), findsOneWidget);
    expect(find.byType(CornerMascot), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Topic mascots fit after scrolling on a compact screen', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await _showScreen(tester, const Size(320, 480), const MathScreen());
    final scroll = tester.state<ScrollableState>(find.byType(Scrollable));
    scroll.position.jumpTo(scroll.position.maxScrollExtent);
    await tester.pumpAndSettle();

    final mascots = find.byType(CornerMascot);
    expect(mascots, findsNWidgets(2));
    final fox = tester.getRect(mascots.first);
    final bunny = tester.getRect(mascots.last);
    expect(fox.width, lessThan(130));
    expect(fox.right, lessThan(bunny.left));
    expect(
      fox.top,
      greaterThan(tester.getRect(find.byType(TopicCard).last).bottom),
    );
    expect(bunny.bottom, lessThanOrEqualTo(480 - 28));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Result mascot has room beside the star on a narrow phone', (
    tester,
  ) async {
    await _showScreen(
      tester,
      const Size(320, 650),
      const ResultScreen(correctAnswers: 8, totalTasks: 10),
    );
    final mascot = tester.getRect(find.byType(CornerMascot));
    final star = tester.getRect(find.byIcon(Icons.star_rounded));
    final home = tester.getRect(find.widgetWithText(ElevatedButton, 'Домой'));
    expect(mascot.right, lessThan(star.left));
    expect(mascot.bottom, lessThan(home.top));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Exercises stay free of mascots and answers remain tappable', (
    tester,
  ) async {
    final answers = <int>[];
    await _showScreen(
      tester,
      const Size(390, 920),
      ExerciseLayout(
        title: '+1',
        example: '0 + 1 = ?',
        currentTask: 1,
        totalTasks: 20,
        feedbackIsCorrect: null,
        feedbackMessage: '',
        minValue: 0,
        maxValue: 10,
        enabled: true,
        onAnswerSelected: answers.add,
      ),
    );
    final mascot = find.byType(CornerMascot);
    final options = find.byType(AnswerOptions);
    expect(mascot, findsNothing);

    tester.view.physicalSize = const Size(390, 480);
    await tester.pumpAndSettle();
    expect(mascot, findsNothing);
    final answer = find.descendant(of: options, matching: find.text('1'));
    await tester.ensureVisible(answer);
    await tester.pump();
    await tester.tap(answer);
    expect(answers, [1]);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _showScreen(WidgetTester tester, Size size, Widget screen) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  tester.view.padding = const FakeViewPadding(top: 24, bottom: 28);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetPadding);
  await tester.pumpWidget(MaterialApp(home: screen));
  await tester.pumpAndSettle();
}
