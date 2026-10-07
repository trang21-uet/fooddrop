import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/food_drop_colors.dart';
import '../../../app/app_theme.dart';
import '../data/timer_providers.dart';
import '../domain/timer_entry.dart';
import '../domain/timer_math.dart';
import 'timer_tiles.dart';

/// A timer that ended longer ago than this rang while the app was closed; its notification already did the work.
const _staleAlertMs = 15000;

/// Wraps the signed-in screens: keeps timers armed, rings finished ones in the foreground, and shows
/// a floating dock while any timer exists (except on the timers screen, which lists them itself).
class TimerDockShell extends ConsumerStatefulWidget {
  const TimerDockShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  ConsumerState<TimerDockShell> createState() => _TimerDockShellState();
}

class _TimerDockShellState extends ConsumerState<TimerDockShell> {
  bool _open = false;

  @override
  void initState() {
    super.initState();
    // OS notifications are the only thing that rings while the app is closed; re-arm them on launch.
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(timerActionsProvider).restore());
  }

  @override
  Widget build(BuildContext context) {
    final timers = ref.watch(timersProvider).value ?? const <TimerEntry>[];
    final showDock = timers.isNotEmpty && !widget.location.startsWith('/timers');

    return Stack(
      children: [
        widget.child,
        if (timers.isNotEmpty) _AlertWatcher(timers: timers),
        if (showDock)
          Positioned(
            left: 16,
            // Clears the floating add button and the detail screen's bottom bar.
            bottom: MediaQuery.paddingOf(context).bottom + 92,
            right: 88,
            child: _Dock(timers: timers, open: _open, onToggle: () => setState(() => _open = !_open)),
          ),
      ],
    );
  }
}

/// Rings each timer the first time a tick finds it at zero (haptics + system sound; the notification
/// is shown by the OS).
class _AlertWatcher extends ConsumerStatefulWidget {
  const _AlertWatcher({required this.timers});

  final List<TimerEntry> timers;

  @override
  ConsumerState<_AlertWatcher> createState() => _AlertWatcherState();
}

class _AlertWatcherState extends ConsumerState<_AlertWatcher> {
  /// (timer id, endsAt) pairs already rung. Keyed on endsAt so extending or resuming a timer re-arms it,
  /// and a tick that lands before the database stream catches up cannot ring it twice.
  final _alerting = <(int, int)>{};

  void _check(int now) {
    for (final timer in widget.timers) {
      if (timer.alertedAtMs != null || !timer.isDone(now) || !_alerting.add((timer.id, timer.clock.endsAtMs))) continue;
      ref.read(timerActionsProvider).markAlerted(timer.id);
      if (now - timer.clock.endsAtMs < _staleAlertMs) {
        HapticFeedback.vibrate();
        SystemSound.play(SystemSoundType.alert);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(tickerProvider, (_, next) {
      final now = next.value;
      if (now != null) _check(now);
    });
    return const SizedBox.shrink();
  }
}

class _Dock extends ConsumerWidget {
  const _Dock({required this.timers, required this.open, required this.onToggle});

  final List<TimerEntry> timers;
  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final now = ref.watch(tickerProvider).value ?? ref.read(nowMsProvider)();
    final running = [for (final t in timers) t.remainingMs(now)].where((ms) => ms > 0);
    final anyDone = running.length < timers.length;
    final summary = anyDone ? 'Có bộ đếm đã xong' : '${formatCountdown(running.reduce((a, b) => a < b ? a : b))} · ${timers.length} bộ đếm';

    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (open)
            Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.5),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.border),
              ),
              child: SingleChildScrollView(child: TimerTiles(timers: timers)),
            ),
          Semantics(
            button: true,
            expanded: open,
            label: 'Bộ đếm giờ: $summary',
            child: Material(
              color: colors.surfaceRaised,
              shape: StadiumBorder(side: BorderSide(color: anyDone ? colors.accentHot : colors.accent)),
              child: InkWell(
                customBorder: const StadiumBorder(),
                onTap: onToggle,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer_outlined, size: 18, color: anyDone ? colors.accentHot : colors.accent),
                        const SizedBox(width: 8),
                        Flexible(child: Text(summary, maxLines: 1, overflow: TextOverflow.ellipsis, style: monoStyle(color: colors.text))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
