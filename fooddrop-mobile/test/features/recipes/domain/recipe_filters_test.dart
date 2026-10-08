import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/recipes/domain/rarity.dart';
import 'package:fooddrop/features/recipes/domain/recipe.dart';
import 'package:fooddrop/features/recipes/domain/recipe_filters.dart';

import '../../../support/recipe_fixtures.dart';

void main() {
  const groups = [
    TagGroup(id: 1, slug: 'cuisine', label: 'Ẩm thực', tags: [
      Tag(id: 10, dimensionId: 1, slug: 'vietnamese', label: 'Việt Nam'),
      Tag(id: 11, dimensionId: 1, slug: 'japanese', label: 'Nhật Bản'),
    ]),
    TagGroup(id: 2, slug: 'equipment', label: 'Dụng cụ', tags: [
      Tag(id: 20, dimensionId: 2, slug: 'oven', label: 'Lò nướng'),
    ]),
  ];

  final pho = domainRecipe(id: 'pho', title: 'Phở bò', rarity: Rarity.pink, tagIds: [10]);
  final katsu = domainRecipe(id: 'katsu', title: 'Cà ri katsu', rarity: Rarity.purple, totalMinutes: 50, tagIds: [11, 20]);
  final banhMi = domainRecipe(
    id: 'banh-mi',
    title: 'Bánh mì',
    rarity: Rarity.white,
    totalMinutes: 15,
    tagIds: [10, 20],
    ingredients: const [
      RecipeIngredient(ingredientId: 'i1', name: 'Thịt nguội', aisle: 'meat'),
    ],
  );
  final all = [pho, katsu, banhMi];

  List<String> ids(RecipeFilters filters) => filters.apply(all, groups).map((r) => r.id).toList();

  test('foldDiacritics strips Vietnamese marks and case', () {
    expect(foldDiacritics('Phở BÒ Đậu hũ'), 'pho bo dau hu');
  });

  test('no filters keeps everything', () {
    expect(ids(const RecipeFilters()), ['pho', 'katsu', 'banh-mi']);
  });

  test('rarity and max minutes narrow the list', () {
    expect(ids(const RecipeFilters(rarity: Rarity.purple)), ['katsu']);
    expect(ids(const RecipeFilters(maxMinutes: 30)), ['banh-mi']);
  });

  test('tags are OR within a dimension and AND across dimensions', () {
    expect(ids(const RecipeFilters(tagIds: {10, 11})), ['pho', 'katsu', 'banh-mi']);
    expect(ids(const RecipeFilters(tagIds: {10, 20})), ['banh-mi']);
    expect(ids(const RecipeFilters(tagIds: {11, 20})), ['katsu']);
  });

  test('search ignores diacritics and matches ingredient names', () {
    expect(ids(const RecipeFilters(query: 'pho')), ['pho']);
    expect(ids(const RecipeFilters(query: 'CA RI')), ['katsu']);
    expect(ids(const RecipeFilters(query: 'thit nguoi')), ['banh-mi']);
    expect(ids(const RecipeFilters(query: 'khong co')), isEmpty);
  });

  test('isActive and sheetFilterCount reflect what is set', () {
    expect(const RecipeFilters().isActive, isFalse);
    expect(const RecipeFilters(query: '  ').isActive, isFalse);
    const filters = RecipeFilters(tagIds: {10, 20}, maxMinutes: 30);
    expect(filters.sheetFilterCount, 3);
    expect(filters.isActive, isTrue);
  });
}
