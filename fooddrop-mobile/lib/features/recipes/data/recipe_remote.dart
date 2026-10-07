import 'package:fooddrop_api/fooddrop_api.dart' as api;

const _pageSize = 50;

/// Thin wrapper over the generated client so the rest of the app never touches its naming.
class RecipeRemote {
  const RecipeRemote(this._api);

  final api.FooddropApi _api;

  api.RecipesApi get _recipes => _api.getRecipesApi();

  /// Walks every page of the keyset-paginated list.
  Future<List<api.RecipeListItemsInner>> listAll() async {
    final items = <api.RecipeListItemsInner>[];
    String? cursor;
    do {
      final page = (await _recipes.recipesControllerList(limit: _pageSize, cursor: cursor)).data!;
      items.addAll(page.items);
      cursor = page.nextCursor;
    } while (cursor != null);
    return items;
  }

  Future<api.RecipeDetail> get(String id) async => (await _recipes.recipesControllerGet(id: id)).data!;

  Future<api.RecipeDetail> create(api.RecipeInput input) async =>
      (await _recipes.recipesControllerCreate(recipeInput: input)).data!;

  Future<api.RecipeDetail> update(String id, api.RecipeInput input) async =>
      (await _recipes.recipesControllerUpdate(id: id, recipeInput: input)).data!;

  Future<void> delete(String id) async {
    await _recipes.recipesControllerRemove(id: id);
  }

  Future<List<api.TagDimension>> tags() async => (await _api.getTagsApi().tagsControllerList()).data!;

  Future<List<api.Ingredient>> searchIngredients(String query) async =>
      (await _api.getIngredientsApi().ingredientsControllerSearch(q: query, limit: 20)).data!;

  Future<api.Ingredient> createIngredient(String name) async => (await _api
          .getIngredientsApi()
          .ingredientsControllerCreate(createIngredient: api.CreateIngredient(name: name)))
      .data!;
}
