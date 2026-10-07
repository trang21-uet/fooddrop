import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_error.dart';
import '../domain/recipe_filters.dart';
import 'recipe_local_store.dart';
import 'recipe_providers.dart';
import 'recipe_remote.dart';

part 'ingredient_catalog.g.dart';

class IngredientOption {
  const IngredientOption({required this.id, required this.name, required this.aisle});

  final String id;
  final String name;
  final String aisle;
}

/// Ingredient search for the recipe form. The catalog lives on the server; offline, it falls back
/// to ingredients already used by synced recipes so editing still works.
class IngredientCatalog {
  const IngredientCatalog(this._remote, this._store);

  final RecipeRemote _remote;
  final RecipeLocalStore _store;

  Future<List<IngredientOption>> search(String query) async {
    try {
      final results = await _remote.searchIngredients(query.trim());
      return [for (final i in results) IngredientOption(id: i.id, name: i.name, aisle: i.aisle.value)];
    } catch (error) {
      if (!isOffline(error)) rethrow;
      final needle = foldDiacritics(query.trim());
      final known = await _store.knownIngredients();
      return [
        for (final row in known)
          if (foldDiacritics(row.name).contains(needle))
            IngredientOption(id: row.ingredientId, name: row.name, aisle: row.aisle),
      ];
    }
  }

  /// Adds a missing ingredient to the shared catalog (needs a connection).
  Future<IngredientOption> create(String name) async {
    final created = await _remote.createIngredient(name.trim());
    return IngredientOption(id: created.id, name: created.name, aisle: created.aisle.value);
  }
}

@riverpod
IngredientCatalog ingredientCatalog(Ref ref) =>
    IngredientCatalog(ref.watch(recipeRemoteProvider), ref.watch(recipeLocalStoreProvider));

@riverpod
Future<List<IngredientOption>> ingredientSearch(Ref ref, String query) =>
    ref.watch(ingredientCatalogProvider).search(query);
