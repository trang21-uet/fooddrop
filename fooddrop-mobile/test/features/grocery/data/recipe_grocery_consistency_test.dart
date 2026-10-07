import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/core/db/app_database.dart';
import 'package:fooddrop/features/grocery/data/grocery_local_store.dart';
import 'package:fooddrop/features/recipes/data/recipe_local_store.dart';
import 'package:fooddrop/features/recipes/domain/recipe_draft.dart';

import '../../../support/recipe_fixtures.dart';
import '../../../support/test_database.dart';

const _draft = RecipeDraft(title: 'Bánh mì', steps: [DraftStep(text: 'Nướng')]);

void main() {
  late AppDatabase db;
  late RecipeLocalStore recipes;
  late GroceryLocalStore grocery;

  setUp(() {
    db = openTestDatabase();
    recipes = RecipeLocalStore(db);
    grocery = GroceryLocalStore(db);
  });
  tearDown(() => db.close());

  Future<Map<String, int>> listed() async =>
      {for (final s in await grocery.watchSelections().first) s.recipeId: s.servings};

  test('a grocery entry follows an offline recipe to its server id', () async {
    final localId = await recipes.saveLocally(_draft);
    await grocery.upsert(localId, 3);
    await grocery.upsert('other', 1);
    final createOp = (await recipes.pendingOps()).single;

    await recipes.replaceLocal(localId, apiDetail(id: 'server-1'), createOp.id);

    expect(await listed(), {'server-1': 3, 'other': 1});
  });

  test('renaming onto an id that is already listed keeps one entry', () async {
    final localId = await recipes.saveLocally(_draft);
    await grocery.upsert(localId, 3);
    await grocery.upsert('server-1', 5);
    final createOp = (await recipes.pendingOps()).single;

    await recipes.replaceLocal(localId, apiDetail(id: 'server-1'), createOp.id);

    expect(await listed(), {'server-1': 5});
  });

  test('deleting a recipe removes it from the grocery list', () async {
    final id = await recipes.saveLocally(_draft);
    await grocery.upsert(id, 2);
    await grocery.upsert('other', 1);

    await recipes.deleteLocally(id);

    expect(await listed(), {'other': 1});
  });

  test('a recipe deleted on the server disappears from the grocery list after sync', () async {
    await recipes.upsertDetail(apiDetail(id: 'gone'));
    await recipes.upsertDetail(apiDetail(id: 'kept'));
    await grocery.upsert('gone', 2);
    await grocery.upsert('kept', 2);

    await recipes.removeMissing({'kept'}, keepIds: {});

    expect(await listed(), {'kept': 2});
  });
}
