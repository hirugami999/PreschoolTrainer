import 'dart:math';

const numberCompositionTaskCount = 10;

class NumberCompositionExample {
  final int left;
  final int right;
  final bool isAddition;

  const NumberCompositionExample(
    this.left,
    this.right, {
    required this.isAddition,
  });

  String get symbol => isAddition ? '+' : '−';
  int get answer => isAddition ? left + right : left - right;
}

List<NumberCompositionExample> generateNumberCompositionExamples(
  int number,
  Random random,
) {
  assert(number >= 3 && number <= 10);
  final additions = [
    for (var left = 0; left <= number; left++)
      NumberCompositionExample(left, number - left, isAddition: true),
  ]..shuffle(random);
  final subtractions = [
    for (var right = 0; right <= number; right++)
      NumberCompositionExample(number, right, isAddition: false),
  ]..shuffle(random);

  const perOperation = numberCompositionTaskCount ~/ 2;
  final examples = [
    ...additions.take(perOperation),
    ...subtractions.take(perOperation),
  ]..shuffle(random);

  if (number == 3) {
    // Each operation has only four expressions. Repeat one of each,
    // excluding the two insertion slots next to its original.
    for (final example in [additions.first, subtractions.first]) {
      final originalIndex = examples.indexOf(example);
      final slot = random.nextInt(examples.length - 1);
      examples.insert(slot < originalIndex ? slot : slot + 2, example);
    }
  }
  return examples;
}
