/// A unit from the server's catalog (`GET /units`). Both names are kept so a locale switch later
/// needs no data change; the app shows the Vietnamese one for now.
class RecipeUnit {
  const RecipeUnit({required this.code, required this.nameVi, required this.nameEn, required this.kind});

  final String code;
  final String nameVi;
  final String nameEn;

  /// `mass` | `volume` | `count` | `other`.
  final String kind;

  String get label => nameVi;
}

/// How a new catalog ingredient should be summed, from the unit a recipe line uses: volume → ml,
/// counts or no unit → pieces, anything else → g. Falls back to pieces while the catalog is empty.
String defaultUnitForRowUnit(String unitCode, Iterable<RecipeUnit> units) {
  final kind = units.where((unit) => unit.code == unitCode).firstOrNull?.kind;
  if (kind == null || kind == 'count') return 'piece';
  return kind == 'volume' ? 'ml' : 'g';
}
