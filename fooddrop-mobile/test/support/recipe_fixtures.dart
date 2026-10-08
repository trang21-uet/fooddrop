import 'package:fooddrop_api/fooddrop_api.dart' as api;
import 'package:fooddrop/features/recipes/domain/rarity.dart';
import 'package:fooddrop/features/recipes/domain/recipe.dart';
import 'package:fooddrop/features/recipes/domain/recipe_unit.dart';

const gramUnit = RecipeUnit(code: 'g', nameVi: 'g', nameEn: 'g', kind: 'mass');
const tbspUnit = RecipeUnit(code: 'tbsp', nameVi: 'thìa canh', nameEn: 'tablespoon', kind: 'volume');
const fruitUnit = RecipeUnit(code: 'fruit', nameVi: 'quả', nameEn: 'fruit', kind: 'count');

/// The unit catalog as the server sends it.
List<api.Unit> apiUnits() => [
      api.Unit(code: 'g', nameVi: 'g', nameEn: 'g', kind: api.UnitKindEnum.mass),
      api.Unit(code: 'tbsp', nameVi: 'thìa canh', nameEn: 'tablespoon', kind: api.UnitKindEnum.volume),
      api.Unit(code: 'fruit', nameVi: 'quả', nameEn: 'fruit', kind: api.UnitKindEnum.count),
    ];

final phoTag = api.RecipeDetailTagsInner(id: 1, slug: 'vietnamese', label: 'Việt Nam', dimension: 'cuisine');
final ovenTag = api.RecipeDetailTagsInner(id: 2, slug: 'oven', label: 'Lò nướng', dimension: 'equipment');

api.RecipeDetail apiDetail({
  String id = 'r1',
  String title = 'Phở bò',
  int totalMinutes = 180,
  int difficulty = 4,
  List<api.RecipeDetailTagsInner>? tags,
  String photoUrl = 'https://cdn.example/a.jpg',
}) =>
    api.RecipeDetail(
      id: id,
      title: title,
      description: null,
      imageUrl: null,
      baseServings: 4,
      totalMinutes: totalMinutes,
      difficulty: difficulty,
      rarity: api.RecipeDetailRarityEnum.pink,
      tags: tags ?? [phoTag],
      createdAt: DateTime.utc(2026, 10, 6),
      sourceUrl: null,
      updatedAt: DateTime.utc(2026, 10, 6),
      steps: [
        api.RecipeDetailStepsInner(
          order: 1,
          name: 'Chần',
          text: 'Chần xương',
          images: [api.RecipeDetailStepsInnerImagesInner(key: 'recipes/u1/a.jpg', url: photoUrl)],
          timerSeconds: 600,
        ),
        api.RecipeDetailStepsInner(order: 0, text: 'Sơ chế', images: []),
      ],
      ingredients: [
        api.RecipeDetailIngredientsInner(
          ingredient: api.RecipeDetailIngredientsInnerIngredient(
            id: 'ing-1',
            name: 'Xương bò',
            aisle: api.RecipeDetailIngredientsInnerIngredientAisleEnum.meat,
          ),
          quantity: 800,
          unit: api.RecipeDetailIngredientsInnerUnit(
            code: 'g',
            nameVi: 'g',
            nameEn: 'g',
            kind: api.RecipeDetailIngredientsInnerUnitKindEnum.mass,
          ),
          note: null,
          base_: api.RecipeDetailIngredientsInnerBase(quantity: 800, unit: api.RecipeDetailIngredientsInnerBaseUnitEnum.g),
        ),
      ],
    );

api.RecipeListItemsInner apiSummary({
  String id = 'r1',
  String title = 'Phở bò',
  List<api.RecipeDetailTagsInner>? tags,
}) =>
    api.RecipeListItemsInner(
      id: id,
      title: title,
      description: null,
      imageUrl: null,
      baseServings: 4,
      totalMinutes: 180,
      difficulty: 4,
      rarity: api.RecipeListItemsInnerRarityEnum.pink,
      tags: tags ?? [phoTag],
      createdAt: DateTime.utc(2026, 10, 6),
    );

api.TagDimension apiTagDimension({
  int id = 1,
  String slug = 'cuisine',
  String label = 'Ẩm thực',
  List<api.TagDimensionTagsInner>? tags,
}) =>
    api.TagDimension(
      id: id,
      slug: slug,
      label: label,
      tags: tags ?? [api.TagDimensionTagsInner(id: 1, slug: 'vietnamese', label: 'Việt Nam')],
    );

Recipe domainRecipe({
  String id = 'r1',
  String title = 'Phở bò',
  Rarity rarity = Rarity.pink,
  int totalMinutes = 180,
  List<int> tagIds = const [],
  List<RecipeIngredient> ingredients = const [],
  List<String>? steps,
}) =>
    Recipe(
      id: id,
      title: title,
      baseServings: 4,
      totalMinutes: totalMinutes,
      difficulty: 3,
      rarity: rarity,
      createdAt: DateTime.utc(2026, 10, 6),
      tagIds: tagIds,
      ingredients: ingredients,
      steps: steps?.map((text) => RecipeStep(text: text)).toList(),
    );
