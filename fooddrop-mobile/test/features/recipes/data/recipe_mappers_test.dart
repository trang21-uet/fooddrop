import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/recipes/data/recipe_mappers.dart';
import 'package:fooddrop/features/recipes/domain/recipe_draft.dart';

void main() {
  const base = RecipeDraft(title: 'Phở', steps: [DraftStep(text: 'Hầm')]);

  test('an uploaded cover is sent by key; its display URL (a local file) is not', () {
    final input = inputFromDraft(base.withCover(imageKey: 'recipes/u1/a.jpg', imageUrl: 'file:///cache/a.jpg'));
    expect((input.imageKey, input.imageUrl), ('recipes/u1/a.jpg', null));
  });

  test('a linked cover is sent as its URL, and a removed one as nothing', () {
    final linked = inputFromDraft(base.withCover(imageUrl: 'https://example.com/a.jpg'));
    expect((linked.imageKey, linked.imageUrl), (null, 'https://example.com/a.jpg'));
    final removed = inputFromDraft(base.withCover(imageUrl: 'https://example.com/a.jpg').withCover());
    expect((removed.imageKey, removed.imageUrl), (null, null));
  });
}
