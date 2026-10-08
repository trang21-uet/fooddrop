import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop_api/fooddrop_api.dart' as api;
import 'package:fooddrop/core/db/app_database.dart';
import 'package:fooddrop/features/recipes/data/recipe_local_store.dart';
import 'package:fooddrop/features/recipes/domain/rarity.dart';
import 'package:fooddrop/features/recipes/domain/recipe.dart';
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
    DraftIngredient(ingredientId: 'i1', name: 'Bánh mì', aisle: 'pantry', quantityText: '2'),
    DraftIngredient(ingredientId: 'i2', name: 'Sốt', aisle: 'other', quantityText: '1 1/2', unitCode: 'tbsp'),
    DraftIngredient(ingredientId: 'i3', name: 'Muối', aisle: 'spices', unitCode: 'g', note: 'tùy khẩu vị'),
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
    await store.replaceUnits(apiUnits());
    final id = await store.saveLocally(_draft);

    expect(isLocalId(id), isTrue);
    final recipe = (await store.watchById(id).first)!;
    expect(recipe.title, 'Bánh mì');
    expect(recipe.rarity, Rarity.white, reason: 'rarity is computed locally until the server answers');
    expect(recipe.isPending, isTrue);
    expect(recipe.steps!.single.timerSeconds, 300);
    expect(recipe.tagIds, [1]);
    expect(recipe.ingredients.map((i) => i.quantityLabel), ['2', '1 1/2 thìa canh', ''], reason: 'raw text plus the chosen unit');
    expect(recipe.ingredients[0].displayQuantity, isNull, reason: 'a plain number is kept as a number, so it scales');
    expect(recipe.ingredients[0].quantity, 2);
    expect(recipe.ingredients[1].displayQuantity, '1 1/2', reason: 'only text Dart cannot read stays raw');
    expect(recipe.ingredients[1].unit?.code, 'tbsp');
    expect(recipe.ingredients[2].unit, isNull, reason: 'a unit without a quantity is dropped, as on the server');

    final ops = await store.pendingOps();
    expect(ops.map((op) => op.kind), ['create']);
    final payload = jsonDecode(ops.single.payloadJson!) as Map<String, dynamic>;
    expect(payload['title'], 'Bánh mì');
    final ingredients = (payload['ingredients'] as List).cast<Map<String, dynamic>>();
    expect(ingredients[0], {'ingredientId': 'i1', 'quantity': '2'});
    expect(ingredients[1], {'ingredientId': 'i2', 'quantity': '1 1/2', 'unit': 'tbsp'});
    expect(ingredients[2], {'ingredientId': 'i3', 'note': 'tùy khẩu vị'}, reason: 'no quantity, so no unit either');
  });

  test('step names and photos are kept locally and sent as storage keys', () async {
    const draft = RecipeDraft(
      title: 'Bánh mì',
      steps: [
        DraftStep(
          name: ' Sơ chế ',
          text: 'Rửa rau',
          images: [RecipeStepImage(key: 'recipes/u1/a.jpg', url: 'file:///cache/a.jpg')],
        ),
        DraftStep(text: 'Nướng bánh'),
      ],
    );
    final id = await store.saveLocally(draft);

    final steps = (await store.watchById(id).first)!.steps!;
    expect((steps[0].name, steps[0].images.single.key, steps[0].images.single.url), ('Sơ chế', 'recipes/u1/a.jpg', 'file:///cache/a.jpg'));
    expect(steps[1].name, isNull, reason: 'a blank name is not stored');
    expect(steps[1].images, isEmpty);

    final payload = jsonDecode((await store.pendingOps()).single.payloadJson!) as Map<String, dynamic>;
    final sent = (payload['steps'] as List).cast<Map<String, dynamic>>();
    expect(sent[0], {'name': 'Sơ chế', 'text': 'Rửa rau', 'images': ['recipes/u1/a.jpg']});
    expect(sent[1].containsKey('name'), isFalse);
  });

  test('details keep the unit names, the grocery base and the step photos from the server', () async {
    await store.upsertDetail(apiDetail());

    final recipe = (await store.watchById('r1').first)!;
    final bones = recipe.ingredients.single;
    expect((bones.quantity, bones.unit?.code, bones.unit?.nameVi, bones.unit?.nameEn), (800, 'g', 'g', 'g'));
    expect((bones.baseQuantity, bones.baseUnit), (800, 'g'));
    final chan = recipe.steps!.last;
    expect((chan.name, chan.images.single.url), ('Chần', 'https://cdn.example/a.jpg'));
  });

  test('the unit catalog is cached in server order', () async {
    expect(await store.watchUnits().first, isEmpty);

    await store.replaceUnits(apiUnits());
    final units = await store.watchUnits().first;
    expect(units.map((u) => u.code), ['g', 'tbsp', 'fruit']);
    expect((units[1].nameVi, units[1].nameEn, units[1].kind), ('thìa canh', 'tablespoon', 'volume'));
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
