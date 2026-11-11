import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preschool_trainer/widgets/topic_card.dart';

const _title = 'Состав числа';

void main() {
  testWidgets('Active card exposes one named button with one tap action', (
    tester,
  ) async {
    var activations = 0;
    await tester.pumpWidget(_appWithCard(() => activations++));

    final card = find.semantics.byLabel(RegExp(_title));
    expect(card, findsOne);
    final node = card.evaluate().single;
    expect(
      node,
      matchesSemantics(
        label: _title,
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    expect(node.childrenCount, 0);

    tester.semantics.tap(card);
    await tester.pump();
    expect(activations, 1);

    final bounds = tester.getRect(find.byType(TopicCard));
    await tester.tapAt(bounds.bottomRight - const Offset(12, 12));
    expect(activations, 2);
  });

  testWidgets('Disabled card keeps one label and cannot be activated', (
    tester,
  ) async {
    var activations = 0;
    await tester.pumpWidget(_appWithCard(() => activations++));
    await tester.pumpWidget(_appWithCard(null));

    final card = find.semantics.byLabel(RegExp(_title));
    expect(card, findsOne);
    final node = card.evaluate().single;
    expect(
      node,
      matchesSemantics(
        label: '$_title. Скоро',
        isButton: true,
        hasEnabledState: true,
      ),
    );
    expect(node.childrenCount, 0);

    tester.semantics.performAction(
      card,
      SemanticsAction.tap,
      checkForAction: false,
    );
    await tester.tap(find.byType(TopicCard));
    await tester.pump();
    expect(activations, 0);
  });
}

Widget _appWithCard(VoidCallback? onPressed) => MaterialApp(
  home: Scaffold(
    body: Center(
      child: SizedBox(
        width: 200,
        height: 210,
        child: TopicCard(title: _title, onPressed: onPressed),
      ),
    ),
  ),
);
