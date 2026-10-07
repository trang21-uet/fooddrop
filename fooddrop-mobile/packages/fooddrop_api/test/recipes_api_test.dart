import 'package:test/test.dart';
import 'package:fooddrop_api/fooddrop_api.dart';


/// tests for RecipesApi
void main() {
  final instance = FooddropApi().getRecipesApi();

  group(RecipesApi, () {
    //Future<RecipeDetail> recipesControllerCreate(RecipeInput recipeInput) async
    test('test recipesControllerCreate', () async {
      // TODO
    });

    //Future<RecipeDetail> recipesControllerGet(String id) async
    test('test recipesControllerGet', () async {
      // TODO
    });

    //Future<RecipeList> recipesControllerList({ String tags, String rarity, int maxMinutes, String q, String cursor, int limit }) async
    test('test recipesControllerList', () async {
      // TODO
    });

    //Future recipesControllerRemove(String id) async
    test('test recipesControllerRemove', () async {
      // TODO
    });

    //Future<RecipeDetail> recipesControllerUpdate(String id, RecipeInput recipeInput) async
    test('test recipesControllerUpdate', () async {
      // TODO
    });

  });
}
