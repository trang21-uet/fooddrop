import '../../recipes/domain/rarity.dart';
import 'gacha_spin.dart';

/// The tab a case sits in: the fixed cases, or one tag dimension.
enum GachaCaseGroup {
  featured('featured'),
  cuisine('cuisine'),
  equipment('equipment'),
  mealType('meal_type'),
  technique('technique'),
  diet('diet');

  const GachaCaseGroup(this.apiValue);

  final String apiValue;

  static GachaCaseGroup? fromApi(String value) {
    for (final group in values) {
      if (group.apiValue == value) return group;
    }
    return null;
  }
}

/// Same shape the backend accepts: `all`, `quick`, `epic` or `<dimension>.<tag>`.
bool isGachaCaseId(String value) => RegExp(r'^(all|quick|epic|[a-z_]+\.[a-z0-9-]+)$').hasMatch(value);

/// What one case holds for the user. Which recipes a case holds is decided by the backend (`GET /gacha/cases`).
class GachaCaseSummary {
  const GachaCaseSummary({
    required this.id,
    required this.group,
    required this.label,
    required this.recipeCount,
    required this.rarityCounts,
    required this.preview,
  });

  /// `all`, `quick`, `epic`, or `<dimension>.<tag>` for a tag case.
  final String id;
  final GachaCaseGroup group;

  /// The tag's label for a tag case; null for featured cases, whose copy the app owns.
  final String? label;
  final int recipeCount;
  final Map<Rarity, int> rarityCounts;

  /// The rarest dishes (up to 10): the case's dish list and the reel shown before a spin.
  final List<GachaCard> preview;
}
