import 'dart:math';

import 'number_composition_examples.dart';

enum MissingNumberType { rightAddend, leftAddend, subtrahend }

class MissingNumberExample {
  final int number;
  final int known;
  final MissingNumberType type;

  const MissingNumberExample(this.number, this.known, this.type);

  int get answer => number - known;

  String expression({required bool revealAnswer}) {
    final missing = revealAnswer ? '$answer' : '?';
    return switch (type) {
      MissingNumberType.rightAddend => '$known + $missing = $number',
      MissingNumberType.leftAddend => '$missing + $known = $number',
      MissingNumberType.subtrahend => '$number − $missing = $known',
    };
  }
}

List<MissingNumberExample> generateMissingNumberExamples(
  int number,
  Random random,
) {
  assert(number >= 3 && number <= 10);
  final pools = [
    for (final type in MissingNumberType.values)
      [
        for (var known = 0; known <= number; known++)
          MissingNumberExample(number, known, type),
      ]..shuffle(random),
  ]..shuffle(random);
  final perType = numberCompositionTaskCount ~/ pools.length;
  final extra = numberCompositionTaskCount % pools.length;
  return [
    for (final pool in pools) ...pool.take(perType),
    for (final pool in pools.take(extra)) pool[perType],
  ]..shuffle(random);
}
