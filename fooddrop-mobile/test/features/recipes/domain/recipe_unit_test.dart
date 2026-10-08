import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/recipes/domain/recipe_unit.dart';

import '../../../support/recipe_fixtures.dart';

void main() {
  group('defaultUnitForRowUnit', () {
    const units = [gramUnit, tbspUnit, fruitUnit, RecipeUnit(code: 'pinch', nameVi: 'nhúm', nameEn: 'pinch', kind: 'other')];

    test('follows the kind of the unit the row uses', () {
      expect(defaultUnitForRowUnit('', units), 'piece', reason: 'no unit means counted pieces');
      expect(defaultUnitForRowUnit('fruit', units), 'piece');
      expect(defaultUnitForRowUnit('tbsp', units), 'ml');
      expect(defaultUnitForRowUnit('g', units), 'g');
      expect(defaultUnitForRowUnit('pinch', units), 'g');
    });

    test('falls back to pieces while the unit catalog has not synced', () {
      expect(defaultUnitForRowUnit('tbsp', const []), 'piece');
    });
  });

  test('units are shown in Vietnamese for now and keep the English name for later', () {
    expect(tbspUnit.label, 'thìa canh');
    expect(tbspUnit.nameEn, 'tablespoon');
  });
}
