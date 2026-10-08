import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/core/db/legacy_outbox_payload.dart';

Map<String, dynamic> _upgrade(List<Map<String, dynamic>> ingredients) {
  final json = upgradeLegacyOutboxPayload(jsonEncode({'title': 'Phở', 'ingredients': ingredients, 'steps': []}));
  return jsonDecode(json) as Map<String, dynamic>;
}

void main() {
  test('keeps g / ml lines and drops a blank unit', () {
    final result = _upgrade([
      {'ingredientId': 'a', 'quantity': '300', 'unit': 'g'},
      {'ingredientId': 'b', 'quantity': '2', 'unit': ''},
    ]);
    expect(result['ingredients'], [
      {'ingredientId': 'a', 'quantity': '300', 'unit': 'g'},
      {'ingredientId': 'b', 'quantity': '2'},
    ]);
  });

  test('moves a free-text unit into the note instead of losing it', () {
    final result = _upgrade([
      {'ingredientId': 'a', 'quantity': '1 1/2', 'unit': 'thìa', 'note': 'đầy'},
      {'ingredientId': 'b', 'quantity': '2', 'unit': 'cup'},
    ]);
    expect(result['ingredients'], [
      {'ingredientId': 'a', 'note': 'đầy — 1 1/2 thìa'},
      {'ingredientId': 'b', 'note': '2 cup'},
    ]);
    expect(result['title'], 'Phở');
  });

  test('leaves payloads without ingredients alone', () {
    expect(jsonDecode(upgradeLegacyOutboxPayload('{"title":"x"}')), {'title': 'x'});
  });
}
