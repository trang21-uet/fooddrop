import '../../recipes/domain/portion_scaling.dart';
import '../../recipes/domain/recipe.dart';

const aisleOrder = ['produce', 'meat', 'seafood', 'dairy', 'pantry', 'spices', 'frozen', 'other'];

const aisleLabels = {
  'produce': 'Rau củ quả',
  'meat': 'Thịt',
  'seafood': 'Hải sản',
  'dairy': 'Trứng & sữa',
  'pantry': 'Đồ khô',
  'spices': 'Gia vị',
  'frozen': 'Đồ đông lạnh',
  'other': 'Khác',
};

class GrocerySelection {
  const GrocerySelection({required this.recipeId, required this.servings});

  final String recipeId;
  final int servings;
}

class GroceryItem {
  const GroceryItem({required this.ingredientId, required this.name, required this.unit, required this.quantity});

  final String ingredientId;
  final String name;
  final String unit;
  final double quantity;

  /// Check marks are keyed per (ingredient, unit): the same ingredient in two units is two lines.
  String get key => '$ingredientId|$unit';

  /// "Cà chua: 550 g"; items with no amount (unknown unit) are just the name.
  String get line => quantity <= 0 ? name : '$name: ${formatQuantity(quantity, unit)}';
}

class GroceryAisleGroup {
  const GroceryAisleGroup({required this.aisle, required this.items});

  final String aisle;
  final List<GroceryItem> items;
}

int _compareText(String a, String b) => a.compareTo(b);

/// Derived state, never persisted. Sums unrounded scaled quantities per (ingredient, unit) and rounds
/// only the total so rounding error does not accumulate. Units are not converted here: the backend
/// already normalizes them. Same rules and vectors as the web app (`docs/fixtures`).
List<GroceryAisleGroup> aggregateGrocery(List<GrocerySelection> selections, Map<String, Recipe> recipesById) {
  final totals = <String, ({RecipeIngredient ingredient, double quantity})>{};
  for (final selection in selections) {
    final recipe = recipesById[selection.recipeId];
    if (recipe == null) continue;
    for (final ingredient in recipe.ingredients) {
      final scaled = scaleQuantity(ingredient.quantity, selection.servings, recipe.baseServings);
      final key = '${ingredient.ingredientId}|${ingredient.unit}';
      final existing = totals[key];
      totals[key] = (ingredient: existing?.ingredient ?? ingredient, quantity: (existing?.quantity ?? 0) + scaled);
    }
  }

  final groups = <GroceryAisleGroup>[];
  for (final aisle in aisleOrder) {
    final items = [
      for (final entry in totals.values)
        if (entry.ingredient.aisle == aisle)
          GroceryItem(
            ingredientId: entry.ingredient.ingredientId,
            name: entry.ingredient.name,
            unit: entry.ingredient.unit,
            quantity: roundForUnit(entry.quantity, entry.ingredient.unit),
          ),
    ]..sort((a, b) => _compareText(a.name, b.name) != 0 ? _compareText(a.name, b.name) : _compareText(a.unit, b.unit));
    if (items.isNotEmpty) groups.add(GroceryAisleGroup(aisle: aisle, items: items));
  }
  return groups;
}

/// Plain-text list of what is still to buy (unticked items), grouped by aisle, for a chat or note app.
String groceryShareText(List<GroceryAisleGroup> groups, Set<String> checked) {
  final sections = [
    for (final group in groups)
      if (group.items.any((item) => !checked.contains(item.key)))
        [
          aisleLabels[group.aisle] ?? group.aisle,
          for (final item in group.items)
            if (!checked.contains(item.key)) '- ${item.line}',
        ].join('\n'),
  ];
  return ['Danh sách đi chợ', if (sections.isEmpty) 'Đã mua đủ.' else ...sections].join('\n\n');
}
