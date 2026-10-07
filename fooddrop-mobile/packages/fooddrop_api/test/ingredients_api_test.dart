import 'package:test/test.dart';
import 'package:fooddrop_api/fooddrop_api.dart';


/// tests for IngredientsApi
void main() {
  final instance = FooddropApi().getIngredientsApi();

  group(IngredientsApi, () {
    //Future<Ingredient> ingredientsControllerCreate(CreateIngredient createIngredient) async
    test('test ingredientsControllerCreate', () async {
      // TODO
    });

    //Future<List<Ingredient>> ingredientsControllerSearch({ String q, int limit }) async
    test('test ingredientsControllerSearch', () async {
      // TODO
    });

  });
}
