import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:preschool_trainer/main.dart';
import 'package:preschool_trainer/screens/math_screen.dart';

void main() {
  for (final size in [
    const Size(320, 568),
    const Size(360, 800),
    const Size(393, 852),
  ]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('Math button fits at $size with text scale $scale', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        await tester.pumpWidget(const PreschoolApp());
        expect(tester.takeException(), isNull);

        final button = find.widgetWithText(ElevatedButton, 'Математика');
        final label = find.descendant(
          of: button,
          matching: find.text('Математика'),
        );
        final arrow = find.descendant(
          of: button,
          matching: find.byIcon(Icons.arrow_forward_rounded),
        );
        final buttonBounds = tester.getRect(button);
        final labelBounds = tester.getRect(label);
        final arrowBounds = tester.getRect(arrow);
        expect(buttonBounds.height, 90);
        expect(
          tester.renderObject<RenderParagraph>(label).didExceedMaxLines,
          isFalse,
        );
        expect(labelBounds.left, greaterThanOrEqualTo(buttonBounds.left));
        expect(labelBounds.right, lessThan(arrowBounds.left));
        expect(arrowBounds.right, lessThanOrEqualTo(buttonBounds.right));
        expect(labelBounds.top, greaterThanOrEqualTo(buttonBounds.top));
        expect(labelBounds.bottom, lessThanOrEqualTo(buttonBounds.bottom));
        expect(arrow.hitTestable(), findsOneWidget);

        await tester.tap(label);
        await tester.pumpAndSettle();
        expect(find.byType(MathScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
