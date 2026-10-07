import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/parser/data/parse_job_mapper.dart';
import 'package:fooddrop/features/parser/data/photo_picker.dart';
import 'package:fooddrop/features/recipes/domain/recipe_draft.dart';
import 'package:fooddrop_api/fooddrop_api.dart' as api;

import '../../support/parser_fixtures.dart';

void main() {
  group('draftFromParseResult', () {
    test('maps fields, preferring the catalog name for matched ingredients', () {
      final draft = draftFromParseResult(parseResult());

      expect(draft.title, 'Thịt kho trứng');
      expect(draft.description, '');
      expect(draft.sourceUrl, 'https://blog.example/thit-kho');
      expect(draft.totalMinutes, 30, reason: 'unknown time falls back to the form default');
      expect(draft.tagIds, {3, 7});
      expect(draft.steps.map((s) => s.timerMinutes), [null, 45]);

      final [pork, quail] = draft.ingredients;
      expect((pork.ingredientId, pork.name, pork.quantityText, pork.unitText), ('ing-pork', 'Thịt ba chỉ', '500', 'g'));
      // Unmatched rows keep an empty id so validation asks the user to add them.
      expect((quail.ingredientId, quail.name, quail.quantityText, quail.unitText, quail.note), ('', 'trứng cút', '12.5', '', 'luộc chín'));
      expect(validateDraft(draft).ingredientRows.keys, [1]);
    });

    test('always leaves one editable step when the source had none', () {
      expect(draftFromParseResult(parseResult(steps: [])).steps, hasLength(1));
    });
  });

  test('formatParsedQuantity never prints trailing zeros', () {
    expect(formatParsedQuantity(500), '500');
    expect(formatParsedQuantity(1.5), '1.5');
    expect(formatParsedQuantity(12.004), '12');
    expect(formatParsedQuantity(250.78), '250.78');
  });

  test('defaultUnitForRowUnit follows the unit text', () {
    expect(defaultUnitForRowUnit(''), 'piece');
    expect(defaultUnitForRowUnit(' ML '), 'ml');
    expect(defaultUnitForRowUnit('kg'), 'g');
  });

  test('contentTypeFor reads MIME types and file names, defaulting to JPEG', () {
    expect(contentTypeFor('image/png'), api.CreateUploadContentTypeEnum.imageSlashPng);
    expect(contentTypeFor('IMG_1.WEBP'), api.CreateUploadContentTypeEnum.imageSlashWebp);
    expect(contentTypeFor('photo.heic'), api.CreateUploadContentTypeEnum.imageSlashJpeg);
  });
}
