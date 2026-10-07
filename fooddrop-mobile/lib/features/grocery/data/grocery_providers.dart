import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/db/database_provider.dart';
import '../../recipes/data/recipe_providers.dart';
import '../domain/grocery_aggregation.dart';
import 'grocery_local_store.dart';

part 'grocery_providers.g.dart';

@Riverpod(keepAlive: true)
GroceryLocalStore groceryLocalStore(Ref ref) => GroceryLocalStore(ref.watch(appDatabaseProvider));

@riverpod
Stream<List<GrocerySelection>> grocerySelections(Ref ref) => ref.watch(groceryLocalStoreProvider).watchSelections();

@riverpod
Stream<Set<String>> groceryChecked(Ref ref) => ref.watch(groceryLocalStoreProvider).watchChecked();

/// The aggregated, aisle-grouped list. Derived from selections + recipes on every change, never stored.
@riverpod
List<GroceryAisleGroup> groceryList(Ref ref) {
  final selections = ref.watch(grocerySelectionsProvider).value ?? const <GrocerySelection>[];
  final recipes = ref.watch(recipesProvider).value ?? const [];
  return aggregateGrocery(selections, {for (final recipe in recipes) recipe.id: recipe});
}

typedef ShareText = Future<void> Function(String text);

/// Opens the system share sheet; tests override it.
@Riverpod(keepAlive: true)
ShareText shareText(Ref ref) => (text) async {
      await SharePlus.instance.share(ShareParams(text: text, title: 'Danh sách đi chợ'));
    };

/// User-initiated changes to the grocery list; they land in Drift and the streams above re-derive.
class GroceryActions {
  GroceryActions(this._ref);

  final Ref _ref;

  GroceryLocalStore get _store => _ref.read(groceryLocalStoreProvider);

  Future<void> addRecipe(String recipeId, int servings) => _store.upsert(recipeId, servings);
  Future<void> setServings(String recipeId, int servings) => _store.upsert(recipeId, servings);
  Future<void> removeRecipe(String recipeId) => _store.remove(recipeId);
  Future<void> toggleChecked(String itemKey) => _store.toggleChecked(itemKey);
  Future<void> uncheckAll() => _store.uncheckAll();
  Future<void> clearAll() => _store.clearAll();
}

@riverpod
GroceryActions groceryActions(Ref ref) => GroceryActions(ref);
