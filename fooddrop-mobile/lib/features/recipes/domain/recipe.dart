import 'portion_scaling.dart';
import 'rarity.dart';

class RecipeStep {
  const RecipeStep({required this.text, this.timerSeconds, this.timerLabel});

  final String text;
  final int? timerSeconds;
  final String? timerLabel;
}

class RecipeIngredient {
  const RecipeIngredient({
    required this.ingredientId,
    required this.name,
    required this.aisle,
    required this.quantity,
    required this.unit,
    this.note,
    this.displayQuantity,
  });

  final String ingredientId;
  final String name;
  final String aisle;
  final double quantity;

  /// `g` | `ml` | `piece`.
  final String unit;
  final String? note;

  /// Raw text for a quantity edited offline, until the server normalizes it.
  final String? displayQuantity;

  /// The number alone: 250, 1.5, 2.
  String get quantityText => formatQuantityNumber(quantity);

  /// "250 g", "2" (pieces), or the raw offline text.
  String get quantityLabel {
    if (displayQuantity != null) return displayQuantity!;
    return formatQuantity(quantity, unit);
  }

  /// [quantityLabel] for [servings] portions. Raw offline text cannot be scaled, so it stays as typed.
  String scaledLabel(int servings, int baseServings) {
    if (servings == baseServings || displayQuantity != null) return quantityLabel;
    return formatQuantity(scaleIngredientQuantity(quantity, unit, servings, baseServings), unit);
  }
}

/// 250 → "250", 1.5 → "1.5"; trims float noise left by unit conversion and scaling.
String formatQuantityNumber(double quantity) {
  final rounded = double.parse(quantity.toStringAsFixed(2));
  return rounded == rounded.roundToDouble() ? rounded.toInt().toString() : rounded.toString();
}

/// "250 g", "2" (pieces).
String formatQuantity(double quantity, String unit) {
  final number = formatQuantityNumber(quantity);
  return unit == 'piece' ? number : '$number $unit';
}

class Tag {
  const Tag({required this.id, required this.dimensionId, required this.slug, required this.label});

  final int id;
  final int dimensionId;
  final String slug;
  final String label;
}

/// A tag dimension (cuisine, equipment, ...) with its tags, for grouped pickers.
class TagGroup {
  const TagGroup({required this.id, required this.slug, required this.label, required this.tags});

  final int id;
  final String slug;
  final String label;
  final List<Tag> tags;
}

class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.baseServings,
    required this.totalMinutes,
    required this.difficulty,
    required this.rarity,
    required this.createdAt,
    this.description,
    this.imageUrl,
    this.sourceUrl,
    this.tagIds = const [],
    this.ingredients = const [],
    this.steps,
    this.isPending = false,
  });

  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? sourceUrl;
  final int baseServings;
  final int totalMinutes;
  final int difficulty;
  final Rarity rarity;
  final DateTime createdAt;
  final List<int> tagIds;
  final List<RecipeIngredient> ingredients;

  /// Null while only the list summary has been synced.
  final List<RecipeStep>? steps;

  /// Has local changes the server has not accepted yet.
  final bool isPending;

  bool get hasDetail => steps != null;
}

/// "20 phút", "3 giờ", "1 giờ 30 phút".
String formatMinutes(int minutes) {
  if (minutes < 60) return '$minutes phút';
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  return rest == 0 ? '$hours giờ' : '$hours giờ $rest phút';
}

/// "10:00" or "2:30:00" for a step timer chip.
String formatTimer(int seconds) {
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final secs = seconds % 60;
  String two(int value) => value.toString().padLeft(2, '0');
  return hours > 0 ? '$hours:${two(minutes)}:${two(secs)}' : '${two(minutes)}:${two(secs)}';
}
