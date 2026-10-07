/// Rarity tiers derived by the backend from `totalMinutes` and `difficulty` (see database schema).
enum Rarity {
  white('white', 'Thường'),
  blue('blue', 'Khá hiếm'),
  purple('purple', 'Hiếm'),
  pink('pink', 'Sử thi'),
  red('red', 'Huyền thoại');

  const Rarity(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static Rarity fromApi(String value) =>
      Rarity.values.firstWhere((rarity) => rarity.apiValue == value, orElse: () => Rarity.white);

  /// Mirror of the generated SQL column, used only for recipes created or edited offline until
  /// the server returns the authoritative value.
  static Rarity fromRecipe({required int totalMinutes, required int difficulty}) {
    if (totalMinutes <= 20 && difficulty <= 1) return Rarity.white;
    if (totalMinutes <= 45 && difficulty <= 2) return Rarity.blue;
    if (totalMinutes <= 90 && difficulty <= 3) return Rarity.purple;
    if (totalMinutes <= 180) return Rarity.pink;
    return Rarity.red;
  }
}
