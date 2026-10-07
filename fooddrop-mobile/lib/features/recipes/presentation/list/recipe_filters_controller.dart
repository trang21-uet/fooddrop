import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/recipe_providers.dart';
import '../../domain/rarity.dart';
import '../../domain/recipe.dart';
import '../../domain/recipe_filters.dart';

part 'recipe_filters_controller.g.dart';

@riverpod
class RecipeFiltersController extends _$RecipeFiltersController {
  @override
  RecipeFilters build() => const RecipeFilters();

  void setQuery(String query) => state = state.copyWith(query: query);

  /// Tapping the active rarity again clears it, like "Tất cả".
  void setRarity(Rarity? rarity) => state = state.copyWith(rarity: () => rarity);

  void toggleTag(int tagId) {
    final next = {...state.tagIds};
    if (!next.remove(tagId)) next.add(tagId);
    state = state.copyWith(tagIds: next);
  }

  void setMaxMinutes(int? minutes) => state = state.copyWith(maxMinutes: () => minutes);

  /// Clears tags and max time (the sheet's filters), keeping search text and rarity.
  void clearSheetFilters() => state = state.copyWith(tagIds: const {}, maxMinutes: () => null);

  void clear() => state = const RecipeFilters();
}

/// Recipes after on-device filtering. Empty while the first load is in flight.
@riverpod
List<Recipe> filteredRecipes(Ref ref) {
  final recipes = ref.watch(recipesProvider).value ?? const <Recipe>[];
  final groups = ref.watch(tagGroupsProvider).value ?? const <TagGroup>[];
  return ref.watch(recipeFiltersControllerProvider).apply(recipes, groups);
}
