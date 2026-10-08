import 'dart:convert';

/// Units the old app could send that the catalog still has under the same code.
const _stillValidUnits = {'g', 'ml'};

/// Rewrites a recipe payload queued by the pre-catalog app (free-text units such as "thìa") so the
/// server does not reject it. A unit the catalog does not know cannot be kept as a unit, so the
/// cook's wording moves into the note ("1 1/2 thìa") instead of being lost.
String upgradeLegacyOutboxPayload(String payloadJson) {
  final payload = jsonDecode(payloadJson) as Map<String, dynamic>;
  final ingredients = payload['ingredients'];
  if (ingredients is List) {
    for (final raw in ingredients) {
      if (raw is! Map<String, dynamic>) continue;
      final unit = (raw['unit'] as String?)?.trim() ?? '';
      if (unit.isEmpty || _stillValidUnits.contains(unit)) {
        if (unit.isEmpty) raw.remove('unit');
        continue;
      }
      final quantity = (raw['quantity'] as String?)?.trim() ?? '';
      raw
        ..remove('unit')
        ..remove('quantity');
      final note = [raw['note'] as String?, '$quantity $unit'.trim()].whereType<String>().where((t) => t.isNotEmpty).join(' — ');
      raw['note'] = note.length > 200 ? note.substring(0, 200) : note;
    }
  }
  return jsonEncode(payload);
}
