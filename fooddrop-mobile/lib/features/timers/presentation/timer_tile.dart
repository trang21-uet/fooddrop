import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_theme.dart';
import '../../../app/food_drop_colors.dart';
import '../data/timer_providers.dart';
import '../domain/timer_entry.dart';
import '../domain/timer_math.dart';

/// One running, paused or finished timer with its controls.
class TimerTile extends ConsumerWidget {
  const TimerTile({super.key, required this.timer, required this.nowMs});

  final TimerEntry timer;
  final int nowMs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final actions = ref.read(timerActionsProvider);
    final paused = timer.clock.isPaused;
    final done = timer.isDone(nowMs);
    final countdown = done ? 'Xong!' : formatCountdown(timer.remainingMs(nowMs));

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: done ? colors.accentHot : colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(timer.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: colors.textMuted)),
          const SizedBox(height: 2),
          Semantics(
            label: '${timer.label}: ${done ? 'đã xong' : countdown}',
            excludeSemantics: true,
            child: Text(
              countdown,
              style: monoStyle(size: 30, color: done ? colors.accentHot : (paused ? colors.textMuted : colors.text)),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (!done)
                _ActionButton(
                  label: paused ? 'Tiếp tục' : 'Tạm dừng',
                  onPressed: () => paused ? actions.resume(timer.id) : actions.pause(timer.id),
                ),
              _ActionButton(label: '+1 phút', onPressed: () => actions.addMinute(timer.id)),
              _ActionButton(label: done ? 'Đóng' : 'Hủy', onPressed: () => actions.cancel(timer.id), emphasized: done),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onPressed, this.emphasized = false});

  final String label;
  final VoidCallback onPressed;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(44, 44),
        foregroundColor: emphasized ? colors.background : colors.text,
        backgroundColor: emphasized ? colors.accent : null,
        side: BorderSide(color: emphasized ? colors.accent : colors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
