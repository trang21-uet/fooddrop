import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/timer_providers.dart';
import '../domain/timer_entry.dart';
import 'timer_tile.dart';

/// Every timer, ticking from the shared ticker. Only the tiles depend on the tick, not the screen around them.
class TimerTiles extends ConsumerWidget {
  const TimerTiles({super.key, required this.timers});

  final List<TimerEntry> timers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(tickerProvider).value ?? ref.read(nowMsProvider)();
    return Column(
      children: [
        for (final timer in timers)
          Padding(padding: const EdgeInsets.only(bottom: 10), child: TimerTile(timer: timer, nowMs: now)),
      ],
    );
  }
}
