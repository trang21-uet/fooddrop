import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/food_drop_colors.dart';
import '../data/gacha_providers.dart';

String _twoDigits(int value) => value.toString().padLeft(2, '0');

/// Latest spins, newest first. Needs a connection; offline it says so and keeps the reel usable.
class SpinHistorySection extends ConsumerWidget {
  const SpinHistorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final history = ref.watch(spinHistoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lần quay gần đây', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        switch (history) {
          AsyncData(:final value) when value.isEmpty =>
            Text('Chưa quay lần nào.', style: TextStyle(color: colors.textMuted)),
          AsyncData(:final value) => Column(
              children: [
                for (final entry in value)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    minTileHeight: 44,
                    leading: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: entry.result == null ? colors.border : colors.rarity(entry.result!.rarity),
                      ),
                    ),
                    title: Text(
                      entry.result?.title ?? 'Món đã xóa',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        color: entry.result == null ? colors.textMuted : colors.text,
                        fontStyle: entry.result == null ? FontStyle.italic : null,
                      ),
                    ),
                    trailing: Text(_formatTime(entry.createdAt), style: TextStyle(fontSize: 12, color: colors.textMuted)),
                    onTap: entry.result == null ? null : () => context.push('/recipes/${entry.result!.id}'),
                  ),
              ],
            ),
          AsyncError() => Text('Không tải được lịch sử.', style: TextStyle(color: colors.textMuted)),
          _ => const Padding(padding: EdgeInsets.all(8), child: LinearProgressIndicator()),
        },
      ],
    );
  }

  static String _formatTime(DateTime time) {
    final local = time.toLocal();
    return '${_twoDigits(local.hour)}:${_twoDigits(local.minute)} ${_twoDigits(local.day)}/${_twoDigits(local.month)}';
  }
}
