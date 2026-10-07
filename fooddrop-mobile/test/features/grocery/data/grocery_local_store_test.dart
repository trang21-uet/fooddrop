import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/core/db/app_database.dart';
import 'package:fooddrop/features/grocery/data/grocery_local_store.dart';

import '../../../support/test_database.dart';

void main() {
  late AppDatabase db;
  late GroceryLocalStore store;

  setUp(() {
    db = openTestDatabase();
    store = GroceryLocalStore(db);
  });
  tearDown(() => db.close());

  test('adding a recipe again replaces its servings instead of duplicating it', () async {
    await store.upsert('r1', 2);
    await store.upsert('r1', 6);
    await store.upsert('r2', 1);

    final selections = await store.watchSelections().first;
    expect({for (final s in selections) s.recipeId: s.servings}, {'r1': 6, 'r2': 1});
  });

  test('ticking toggles, and uncheck-all clears every tick', () async {
    await store.toggleChecked('tomato|g');
    await store.toggleChecked('egg|piece');
    expect(await store.watchChecked().first, {'tomato|g', 'egg|piece'});

    await store.toggleChecked('tomato|g');
    expect(await store.watchChecked().first, {'egg|piece'});

    await store.uncheckAll();
    expect(await store.watchChecked().first, isEmpty);
  });

  test('removing and clearing', () async {
    await store.upsert('r1', 2);
    await store.upsert('r2', 2);
    await store.toggleChecked('tomato|g');

    await store.remove('r1');
    expect((await store.watchSelections().first).map((s) => s.recipeId), ['r2']);

    await store.clearAll();
    expect(await store.watchSelections().first, isEmpty);
    expect(await store.watchChecked().first, isEmpty);
  });

  test('sign-out wipes grocery and timers with everything else', () async {
    await store.upsert('r1', 2);
    await db.into(db.timerEntries).insert(TimerEntriesCompanion.insert(label: 'a', endsAtMs: 1));

    await db.wipe();

    expect(await store.watchSelections().first, isEmpty);
    expect(await db.select(db.timerEntries).get(), isEmpty);
  });
}
