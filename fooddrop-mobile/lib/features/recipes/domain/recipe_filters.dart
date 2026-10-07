import 'rarity.dart';
import 'recipe.dart';

const maxMinutesOptions = [15, 30, 60];

/// Filters are applied on-device over the synced recipes so they work offline and need no request.
class RecipeFilters {
  const RecipeFilters({this.tagIds = const {}, this.rarity, this.maxMinutes, this.query = ''});

  final Set<int> tagIds;
  final Rarity? rarity;
  final int? maxMinutes;
  final String query;

  /// Count of filters set in the bottom sheet (tags + max time), shown as a badge.
  int get sheetFilterCount => tagIds.length + (maxMinutes == null ? 0 : 1);

  bool get isActive => sheetFilterCount > 0 || rarity != null || query.trim().isNotEmpty;

  RecipeFilters copyWith({
    Set<int>? tagIds,
    Rarity? Function()? rarity,
    int? Function()? maxMinutes,
    String? query,
  }) =>
      RecipeFilters(
        tagIds: tagIds ?? this.tagIds,
        rarity: rarity != null ? rarity() : this.rarity,
        maxMinutes: maxMinutes != null ? maxMinutes() : this.maxMinutes,
        query: query ?? this.query,
      );

  /// OR within a tag dimension, AND across dimensions (same rule as the backend).
  List<Recipe> apply(List<Recipe> recipes, List<TagGroup> groups) {
    final selectedByDimension = <int, Set<int>>{};
    for (final group in groups) {
      final selected = group.tags.map((tag) => tag.id).where(tagIds.contains).toSet();
      if (selected.isNotEmpty) selectedByDimension[group.id] = selected;
    }
    final needle = foldDiacritics(query.trim());

    return recipes.where((recipe) {
      if (rarity != null && recipe.rarity != rarity) return false;
      if (maxMinutes != null && recipe.totalMinutes > maxMinutes!) return false;
      for (final selected in selectedByDimension.values) {
        if (!recipe.tagIds.any(selected.contains)) return false;
      }
      if (needle.isEmpty) return true;
      return matchesQuery(recipe, needle);
    }).toList();
  }
}

bool matchesQuery(Recipe recipe, String foldedNeedle) {
  final haystacks = [
    recipe.title,
    recipe.description ?? '',
    ...recipe.ingredients.map((ingredient) => ingredient.name),
  ];
  return haystacks.any((text) => foldDiacritics(text).contains(foldedNeedle));
}

const _diacriticGroups = {
  'a': 'àáảãạăằắẳẵặâầấẩẫậ',
  'e': 'èéẻẽẹêềếểễệ',
  'i': 'ìíỉĩị',
  'o': 'òóỏõọôồốổỗộơờớởỡợ',
  'u': 'ùúủũụưừứửữự',
  'y': 'ỳýỷỹỵ',
  'd': 'đ',
};

final _diacriticMap = {
  for (final entry in _diacriticGroups.entries)
    for (final char in entry.value.split('')) char: entry.key,
};

/// Lower-cases and strips Vietnamese diacritics so "pho bo" finds "Phở bò".
String foldDiacritics(String input) {
  final buffer = StringBuffer();
  for (final char in input.toLowerCase().split('')) {
    buffer.write(_diacriticMap[char] ?? char);
  }
  return buffer.toString();
}
