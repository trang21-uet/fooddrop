import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/recipes/domain/portion_scaling.dart';

void main() {
  // Vectors shared with the web app; flutter test runs from the fooddrop-mobile folder.
  final cases = jsonDecode(File('../docs/fixtures/portion-scaling-cases.json').readAsStringSync()) as Map<String, dynamic>;

  group('roundForUnit (shared vectors)', () {
    for (final c in (cases['round'] as List).cast<Map<String, dynamic>>()) {
      test('${c['quantity']} ${c['unit']} -> ${c['expected']}', () {
        expect(roundForUnit((c['quantity'] as num).toDouble(), c['unit'] as String), (c['expected'] as num).toDouble());
      });
    }
  });

  group('scaleIngredientQuantity (shared vectors)', () {
    for (final c in (cases['scale'] as List).cast<Map<String, dynamic>>()) {
      test('${c['quantity']} ${c['unit']} x ${c['servings']}/${c['baseServings']} -> ${c['expected']}', () {
        final actual = scaleIngredientQuantity(
          (c['quantity'] as num).toDouble(),
          c['unit'] as String,
          c['servings'] as int,
          c['baseServings'] as int,
        );
        expect(actual, (c['expected'] as num).toDouble());
      });
    }
  });
}
