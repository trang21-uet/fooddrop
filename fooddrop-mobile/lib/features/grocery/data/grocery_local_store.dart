import '../../../core/db/app_database.dart';
import '../domain/grocery_aggregation.dart';

/// Persists only `{recipeId, servings}` and ticked keys; the aggregated list is a derived provider.
class GroceryLocalStore {
  GroceryLocalStore(this._db);

  final AppDatabase _db;

  Stream<List<GrocerySelection>> watchSelections() => _db
      .select(_db.grocerySelections)
      .watch()
      .map((rows) => [for (final row in rows) GrocerySelection(recipeId: row.recipeId, servings: row.servings)]);

  Stream<Set<String>> watchChecked() =>
      _db.select(_db.groceryChecks).watch().map((rows) => {for (final row in rows) row.itemKey});

  /// Adding a recipe that is already listed replaces its servings.
  Future<void> upsert(String recipeId, int servings) => _db
      .into(_db.grocerySelections)
      .insertOnConflictUpdate(GrocerySelectionsCompanion.insert(recipeId: recipeId, servings: servings));

  Future<void> remove(String recipeId) =>
      (_db.delete(_db.grocerySelections)..where((t) => t.recipeId.equals(recipeId))).go();

  Future<void> toggleChecked(String itemKey) => _db.transaction(() async {
        final existing = await (_db.select(_db.groceryChecks)..where((t) => t.itemKey.equals(itemKey))).getSingleOrNull();
        if (existing == null) {
          await _db.into(_db.groceryChecks).insert(GroceryChecksCompanion.insert(itemKey: itemKey));
        } else {
          await (_db.delete(_db.groceryChecks)..where((t) => t.itemKey.equals(itemKey))).go();
        }
      });

  Future<void> uncheckAll() => _db.delete(_db.groceryChecks).go();

  Future<void> clearAll() => _db.transaction(() async {
        await _db.delete(_db.grocerySelections).go();
        await _db.delete(_db.groceryChecks).go();
      });
}
