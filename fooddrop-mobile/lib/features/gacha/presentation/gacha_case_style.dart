import 'package:flutter/material.dart';

import '../domain/gacha_case.dart';

/// Copy and accent per case (same values and palette hash as web `gacha-case-styles.ts`).
class GachaCaseStyle {
  const GachaCaseStyle({required this.name, required this.rule, required this.tag, required this.color});

  final String name;
  final String rule;
  final String tag;
  final Color color;

  static const _featured = {
    'all': GachaCaseStyle(name: 'Hòm Tổng hợp', rule: 'Mọi công thức của bạn', tag: 'TẤT CẢ', color: Color(0xFFFF8A1F)),
    'quick': GachaCaseStyle(name: 'Hòm Nhanh gọn', rule: 'Xong trong 30 phút', tag: 'NHANH', color: Color(0xFF6BBF59)),
    'epic': GachaCaseStyle(name: 'Hòm Cầu kỳ', rule: 'Món Sử thi và Huyền thoại', tag: 'CẦU KỲ', color: Color(0xFFFF3B30)),
  };

  /// Tag cases pick from this palette by id, so a case keeps its colour.
  static const _tagPalette = [
    Color(0xFFFF8A1F),
    Color(0xFFFFC233),
    Color(0xFF3DD6C6),
    Color(0xFF8FA3FF),
    Color(0xFF6BBF59),
    Color(0xFFFF6FB5),
    Color(0xFFB98CFF),
    Color(0xFFFF3B30),
  ];

  static GachaCaseStyle of(GachaCaseSummary summary) {
    final featured = _featured[summary.id];
    if (featured != null) return featured;
    final label = summary.label ?? summary.id;
    var hash = 0;
    for (final unit in summary.id.codeUnits) {
      hash = (hash * 31 + unit) % 9973;
    }
    return GachaCaseStyle(
      name: 'Hòm $label',
      rule: 'Món gắn thẻ $label',
      tag: label.toUpperCase(),
      color: _tagPalette[hash % _tagPalette.length],
    );
  }
}

/// Tab names of the case picker, in tab order.
String gachaCaseGroupLabel(GachaCaseGroup group) => switch (group) {
      GachaCaseGroup.featured => 'Nổi bật',
      GachaCaseGroup.cuisine => 'Ẩm thực',
      GachaCaseGroup.equipment => 'Dụng cụ',
      GachaCaseGroup.mealType => 'Loại món',
      GachaCaseGroup.technique => 'Cách nấu',
      GachaCaseGroup.diet => 'Chế độ ăn',
    };
