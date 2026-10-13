import 'package:flutter/material.dart';

import '../domain/gacha_case.dart';

/// Copy and accent per case (same values as web `gacha-case-styles.ts`).
class GachaCaseStyle {
  const GachaCaseStyle({required this.name, required this.rule, required this.tag, required this.color});

  final String name;
  final String rule;
  final String tag;
  final Color color;

  static GachaCaseStyle of(GachaCaseId id) => switch (id) {
        GachaCaseId.all => const GachaCaseStyle(name: 'Hòm Tổng hợp', rule: 'Mọi công thức của bạn', tag: 'TẤT CẢ', color: Color(0xFFFF8A1F)),
        GachaCaseId.breakfast => const GachaCaseStyle(name: 'Hòm Bữa sáng', rule: 'Món gắn thẻ Bữa sáng', tag: 'SÁNG', color: Color(0xFFFFC233)),
        GachaCaseId.lunch => const GachaCaseStyle(name: 'Hòm Bữa trưa', rule: 'Món gắn thẻ Bữa trưa', tag: 'TRƯA', color: Color(0xFF3DD6C6)),
        GachaCaseId.dinner => const GachaCaseStyle(name: 'Hòm Bữa tối', rule: 'Món gắn thẻ Bữa tối', tag: 'TỐI', color: Color(0xFF8FA3FF)),
        GachaCaseId.quick => const GachaCaseStyle(name: 'Hòm Nhanh gọn', rule: 'Xong trong 30 phút', tag: 'NHANH', color: Color(0xFF6BBF59)),
        GachaCaseId.epic => const GachaCaseStyle(name: 'Hòm Cầu kỳ', rule: 'Món Sử thi và Huyền thoại', tag: 'CẦU KỲ', color: Color(0xFFFF3B30)),
      };
}
