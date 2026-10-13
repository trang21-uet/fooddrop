import '../../recipes/domain/rarity.dart';
import 'gacha_spin.dart';

/// The cook cases ("hòm"). Which recipes a case holds is decided by the backend (`GET /gacha/cases`);
/// the app owns only their copy and colours.
enum GachaCaseId {
  all('all'),
  breakfast('breakfast'),
  lunch('lunch'),
  dinner('dinner'),
  quick('quick'),
  epic('epic');

  const GachaCaseId(this.apiValue);

  final String apiValue;

  static GachaCaseId? fromApi(String value) {
    for (final id in values) {
      if (id.apiValue == value) return id;
    }
    return null;
  }
}

/// What one case holds for the user.
class GachaCaseSummary {
  const GachaCaseSummary({
    required this.id,
    required this.recipeCount,
    required this.rarityCounts,
    required this.preview,
  });

  final GachaCaseId id;
  final int recipeCount;
  final Map<Rarity, int> rarityCounts;

  /// The rarest dishes (up to 10): the case's dish list and the reel shown before a spin.
  final List<GachaCard> preview;
}
