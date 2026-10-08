import 'dart:convert';

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/core/db/app_database.dart';

/// A v2 database as shipped before recipe units: normalized quantities, no unit names, no base.
void _createV2(dynamic raw) {
  raw.execute('''
    CREATE TABLE recipes (
      id TEXT NOT NULL PRIMARY KEY, title TEXT NOT NULL, description TEXT, image_url TEXT, source_url TEXT,
      base_servings INTEGER NOT NULL, total_minutes INTEGER NOT NULL, difficulty INTEGER NOT NULL,
      rarity TEXT NOT NULL, steps_json TEXT, created_at INTEGER NOT NULL
    )''');
  raw.execute('''
    CREATE TABLE recipe_ingredients (
      recipe_id TEXT NOT NULL REFERENCES recipes (id) ON DELETE CASCADE, ingredient_id TEXT NOT NULL,
      name TEXT NOT NULL, aisle TEXT NOT NULL, quantity REAL NOT NULL, unit TEXT NOT NULL, note TEXT,
      sort_order INTEGER NOT NULL, display_quantity TEXT, PRIMARY KEY (recipe_id, ingredient_id)
    )''');
  raw.execute("INSERT INTO recipes VALUES ('r1', 'Phở', NULL, NULL, NULL, 2, 30, 2, 'blue', '[]', 0)");
  raw.execute("INSERT INTO recipe_ingredients VALUES ('r1', 'beef', 'Thịt bò', 'meat', 300, 'g', NULL, 0, NULL)");
  raw.execute("INSERT INTO recipe_ingredients VALUES ('r1', 'milk', 'Sữa', 'dairy', 200, 'ml', NULL, 1, NULL)");
  raw.execute("INSERT INTO recipe_ingredients VALUES ('r1', 'egg', 'Trứng', 'dairy', 2, 'piece', 'luộc', 2, NULL)");
  raw.execute("INSERT INTO recipe_ingredients VALUES ('r1', 'sauce', 'Sốt', 'pantry', 0, 'piece', NULL, 3, '1 1/2 thìa')");
  raw.execute("INSERT INTO recipe_ingredients VALUES ('r1', 'salt', 'Muối', 'spices', 0, 'g', '1 nắm', 4, NULL)");
  raw.execute('CREATE TABLE outbox (id INTEGER PRIMARY KEY AUTOINCREMENT, kind TEXT NOT NULL, recipe_id TEXT NOT NULL, payload_json TEXT, created_at INTEGER NOT NULL)');
  raw.execute('''INSERT INTO outbox (kind, recipe_id, payload_json, created_at) VALUES ('create', 'local-1', '{"ingredients":[{"ingredientId":"sauce","quantity":"1 1/2","unit":"thìa"}]}', 0)''');
  raw.execute("INSERT INTO outbox (kind, recipe_id, payload_json, created_at) VALUES ('delete', 'r9', NULL, 0)");
  raw.execute('PRAGMA user_version = 2');
}

void main() {
  test('upgrading from v2 keeps g / ml as written, turns pieces into "no unit" and seeds the grocery base', () async {
    final db = AppDatabase(NativeDatabase.memory(setup: _createV2));
    addTearDown(db.close);

    final rows = await (db.select(db.recipeIngredients)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();

    final [beef, milk, egg, sauce, salt] = rows;
    expect((beef.quantity, beef.unit, beef.unitNameVi, beef.unitKind), (300, 'g', 'g', 'mass'));
    expect((beef.baseQuantity, beef.baseUnit), (300, 'g'));
    expect((milk.unit, milk.unitKind, milk.baseUnit), ('ml', 'volume', 'ml'));
    expect((egg.quantity, egg.unit, egg.unitNameVi), (2, null, null), reason: 'a bare count has no unit');
    expect((egg.baseQuantity, egg.baseUnit), (2, 'piece'));
    expect(sauce.displayQuantity, '1 1/2 thìa', reason: 'raw offline text survives');
    expect((salt.quantity, salt.unit, salt.unitNameVi, salt.unitKind, salt.note), (null, null, null, null, '1 nắm'), reason: 'legacy "0 g" line keeps only its note');
    expect(salt.baseQuantity, 0);
    expect(await db.select(db.units).get(), isEmpty, reason: 'the catalog arrives with the next sync');
  });

  test('upgrading rewrites queued edits so a free-text unit is not rejected by the server', () async {
    final db = AppDatabase(NativeDatabase.memory(setup: _createV2));
    addTearDown(db.close);

    final ops = await db.select(db.outbox).get();

    expect(jsonDecode(ops.first.payloadJson!), {
      'ingredients': [
        {'ingredientId': 'sauce', 'note': '1 1/2 thìa'},
      ],
    });
    expect(ops.last.payloadJson, isNull, reason: 'a queued delete has no payload');
  });
}
