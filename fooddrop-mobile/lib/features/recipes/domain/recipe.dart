import 'portion_scaling.dart';
import 'rarity.dart';
import 'recipe_unit.dart';

/// A photo attached to a step. `url` is a network URL once the server has seen the recipe, or a
/// `file:` URI for a photo picked on this device that has not synced yet.
class RecipeStepImage {
  const RecipeStepImage({required this.key, this.url});

  /// Object-storage key from `POST /media/uploads`; this is what gets saved.
  final String key;
  final String? url;
}

class RecipeStep {
  const RecipeStep({this.name, required this.text, this.note, this.images = const [], this.timerSeconds, this.timerLabel});

  /// Short heading ("Sơ chế"); the instructions are in [text].
  final String? name;
  final String text;

  /// Optional tip or warning for the step ("Ướp ít nhất 20 phút").
  final String? note;
  final List<RecipeStepImage> images;
  final int? timerSeconds;
  final String? timerLabel;
}

class RecipeIngredient {
  const RecipeIngredient({
    required this.ingredientId,
    required this.name,
    required this.aisle,
    this.quantity,
    this.unit,
    this.note,
    this.baseQuantity = 0,
    this.baseUnit = 'piece',
    this.displayQuantity,
  });

  final String ingredientId;
  final String name;
  final String aisle;

  /// As the cook wrote it; both quantity and unit are optional ("muối, tùy khẩu vị").
  final double? quantity;
  final RecipeUnit? unit;
  final String? note;

  /// What the grocery list sums, converted by the server to `g` | `ml` | `piece`. Zero until a
  /// recipe edited offline has synced: the app never converts units itself.
  final double baseQuantity;
  final String baseUnit;

  /// Raw text ("1 1/2") for a quantity edited offline that Dart cannot read as a plain number.
  final String? displayQuantity;

  /// The number alone for the form: "1 1/2" as typed offline, else 250, 1.5, 2; empty when absent.
  String get quantityText => displayQuantity ?? (quantity == null ? '' : formatQuantityNumber(quantity!));

  /// "2 thìa canh", "2" (no unit), "" (no quantity).
  String get quantityLabel => formatAmount(quantityText, unit);

  /// [quantityLabel] for [servings] portions. Raw offline text cannot be scaled, so it stays as typed.
  String scaledLabel(int servings, int baseServings) {
    if (servings == baseServings || displayQuantity != null || quantity == null) return quantityLabel;
    final scaled = scaleIngredientQuantity(quantity!, unit?.code, servings, baseServings);
    return formatAmount(formatQuantityNumber(scaled), unit);
  }
}

/// 250 → "250", 1.5 → "1.5"; trims float noise left by scaling.
String formatQuantityNumber(double quantity) {
  final rounded = double.parse(quantity.toStringAsFixed(2));
  return rounded == rounded.roundToDouble() ? rounded.toInt().toString() : rounded.toString();
}

/// "2 thìa canh", "2" (no unit), "" (no quantity): a recipe line as written.
String formatAmount(String quantityText, RecipeUnit? unit) {
  if (quantityText.isEmpty) return '';
  return unit == null ? quantityText : '$quantityText ${unit.label}';
}

/// Grocery totals in the server's base units: "250 g", "2" (pieces).
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
