import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop_api/fooddrop_api.dart' as api;
import 'package:fooddrop/core/db/app_database.dart';
import 'package:fooddrop/features/recipes/data/recipe_local_store.dart';
import 'package:fooddrop/features/recipes/domain/rarity.dart';
import 'package:fooddrop/features/recipes/domain/recipe_draft.dart';

import '../../../support/recipe_fixtures.dart';
import '../../../support/test_database.dart';

const _draft = RecipeDraft(
  title: '  Bánh mì  ',
  totalMinutes: 15,
  difficulty: 1,
  tagIds: {1},
  steps: [DraftStep(text: 'Nướng bánh', timerMinutes: 5)],
  ingredients: [
    DraftIngredient(ingredientId: 'i1', name: 'Bánh mì', aisle: 'pantry', quantityText: '2', unitText: ''),
    DraftIngredient(ingredientId: 'i2', name: 'Sốt', aisle: 'other', quantityText: '1 1/2', unitText: 'thìa'),
  ],
);

void main() {
  late AppDatabase db;
  late RecipeLocalStore store;

  setUp(() {
    db = openTestDatabase();
    store = RecipeLocalStore(db);
  });
  tearDown(() => db.close());

  test('saving a new recipe writes it locally and queues a create', () async {
    final id = await store.saveLocally(_draft);

    expect(isLocalId(id), isTrue);
    final recipe = (await store.watchById(id).first)!;
    expect(recipe.title, 'Bánh mì');
    expect(recipe.rarity, Rarity.white, reason: 'rarity is computed locally until the server answers');
    expect(recipe.isPending, isTrue);
    expect(recipe.steps!.single.timerSeconds, 300);
    expect(recipe.tagIds, [1]);
    expect(recipe.ingredients.map((i) => i.quantityLabel), ['2', '1 1/2 thìa'], reason: 'raw text until normalized');

    final ops = await store.pendingOps();
    expect(ops.map((op) => op.kind), ['create']);
    final payload = jsonDecode(ops.single.payloadJson!) as Map<String, dynamic>;
    expect(payload['title'], 'Bánh mì');
    expect((payload['ingredients'] as List).last['quantity'], '1 1/2');
  });

  test('editing a not-yet-synced recipe updates the queued create instead of adding an op', () async {
    final id = await store.saveLocally(_draft);
    await store.saveLocally(_draft.copyWith(title: 'Bánh mì nướng'), id: id);

    final ops = await store.pendingOps();
    expect(ops.map((op) => op.kind), ['create']);
    expect(jsonDecode(ops.single.payloadJson!)['title'], 'Bánh mì nướng');
  });

  test('editing a synced recipe queues one update, later edits replace it', () async {
    await store.upsertDetail(apiDetail());
    await store.saveLocally(_draft.copyWith(title: 'v1'), id: 'r1');
    await store.saveLocally(_draft.copyWith(title: 'v2'), id: 'r1');

    final ops = await store.pendingOps();
    expect(ops.map((op) => op.kind), ['update']);
    expect(jsonDecode(ops.single.payloadJson!)['title'], 'v2');
    expect((await store.watchById('r1').first)!.title, 'v2');
  });

  test('deleting a recipe the server never saw leaves no trace in the outbox', () async {
    final id = await store.saveLocally(_draft);
    await store.deleteLocally(id);

    expect(await store.pendingOps(), isEmpty);
    expect(await store.watchById(id).first, isNull);
  });

  test('deleting a synced recipe queues a delete and drops its pending update', () async {
    await store.upsertDetail(apiDetail());
    await store.saveLocally(_draft, id: 'r1');
    await store.deleteLocally('r1');

    expect((await store.pendingOps()).map((op) => op.kind), ['delete']);
    expect(await store.watchById('r1').first, isNull);
  });

  test('list summaries keep an already synced detail and skip recipes with pending edits', () async {
    await store.upsertDetail(apiDetail(id: 'a', title: 'Cũ'));
    await store.upsertDetail(apiDetail(id: 'b', title: 'Đang sửa'));

    await store.applySummaries(
      [apiSummary(id: 'a', title: 'Mới'), apiSummary(id: 'b', title: 'Từ server')],
      skipIds: {'b'},
    );

    final recipes = {for (final r in await store.watchAll().first) r.id: r};
    expect(recipes['a']!.title, 'Mới');
    expect(recipes['a']!.steps, hasLength(2), reason: 'summary must not wipe the downloaded steps');
    expect(recipes['a']!.ingredients, hasLength(1));
    expect(recipes['b']!.title, 'Đang sửa');
  });

  test('details are stored with steps in order, and idsMissingDetail lists summary-only recipes', () async {
    await store.upsertDetail(apiDetail());
    await store.applySummaries([apiSummary(id: 'only-summary')], skipIds: {});

    final recipe = (await store.watchById('r1').first)!;
    expect(recipe.steps!.map((s) => s.text), ['Sơ chế', 'Chần xương']);
    expect(await store.idsMissingDetail(), ['only-summary']);
  });

  test('removeMissing deletes recipes gone from the server but keeps pending ones', () async {
    await store.upsertDetail(apiDetail(id: 'keep'));
    await store.upsertDetail(apiDetail(id: 'gone'));
    await store.upsertDetail(apiDetail(id: 'pending'));

    await store.removeMissing({'keep'}, keepIds: {'pending'});

    expect((await store.watchAll().first).map((r) => r.id).toSet(), {'keep', 'pending'});
  });

  test('tags are cached and grouped by dimension', () async {
    await store.replaceTags([
      apiTagDimension(),
      apiTagDimension(
        id: 2,
        slug: 'equipment',
        label: 'Dụng cụ',
        tags: [api.TagDimensionTagsInner(id: 2, slug: 'oven', label: 'Lò nướng')],
      ),
    ]);
    final groups = await store.watchTagGroups().first;
    expect(groups.map((g) => g.slug), ['cuisine', 'equipment']);
    expect(groups.first.tags.single.label, 'Việt Nam');
  });

  test('wipe removes all user data', () async {
    await store.upsertDetail(apiDetail());
    await store.saveLocally(_draft);
    await db.wipe();
    expect(await store.watchAll().first, isEmpty);
    expect(await store.pendingOps(), isEmpty);
  });
}
