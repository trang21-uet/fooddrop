import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/food_drop_colors.dart';
import '../../../core/widgets/neon_button.dart';
import '../data/timer_providers.dart';
import 'timer_tiles.dart';

const _maxMinutes = 24 * 60;

class TimersScreen extends ConsumerStatefulWidget {
  const TimersScreen({super.key});

  @override
  ConsumerState<TimersScreen> createState() => _TimersScreenState();
}

class _TimersScreenState extends ConsumerState<TimersScreen> {
  final _label = TextEditingController();
  final _minutes = TextEditingController(text: '10');
  late final AppLifecycleListener _lifecycle;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Coming back from the system "alarms" screen: re-check the permission and re-arm notifications.
    _lifecycle = AppLifecycleListener(onResume: _recheckExactAlarms);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _label.dispose();
    _minutes.dispose();
    super.dispose();
  }

  Future<void> _recheckExactAlarms() async {
    ref.invalidate(exactAlarmsAllowedProvider);
    await ref.read(timerActionsProvider).restore();
  }

  Future<void> _start() async {
    final minutes = double.tryParse(_minutes.text.trim().replaceAll(',', '.'));
    if (minutes == null || minutes <= 0 || minutes > _maxMinutes) {
      setState(() => _error = 'Nhập số phút từ 1 đến $_maxMinutes.');
      return;
    }
    setState(() => _error = null);
    final label = _label.text;
    _label.clear();
    await ref.read(timerActionsProvider).start(label, Duration(milliseconds: (minutes * 60000).round()));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final timers = ref.watch(timersProvider).value ?? const [];
    final exactAllowed = ref.watch(exactAlarmsAllowedProvider).value ?? true;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.canPop() ? context.pop() : context.go('/recipes')),
        title: const Text('Hẹn giờ', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          if (!exactAllowed) ...[
            _ExactAlarmBanner(onAllow: () => ref.read(timerNotificationSchedulerProvider).requestExactAlarms()),
            const SizedBox(height: 16),
          ],
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _label,
                  maxLength: 60,
                  decoration: const InputDecoration(labelText: 'Tên (tùy chọn)', counterText: ''),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _minutes,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Số phút', errorText: _error),
                  onSubmitted: (_) => _start(),
                ),
                const SizedBox(height: 16),
                NeonButton(label: 'Bắt đầu', icon: Icons.play_arrow_rounded, height: 48, onPressed: _start),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (timers.isEmpty)
            Text(
              'Chưa có bộ đếm nào. Bắt đầu một bộ ở trên hoặc từ bước nấu trong công thức.',
              style: TextStyle(fontSize: 14, color: colors.textMuted),
            )
          else
            TimerTiles(timers: timers),
        ],
      ),
    );
  }
}

/// Android 14+ makes exact alarms opt-in; without it the OS may delay the "done" notification.
class _ExactAlarmBanner extends StatelessWidget {
  const _ExactAlarmBanner({required this.onAllow});

  final VoidCallback onAllow;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.accent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông báo có thể trễ vài phút khi app đóng, vì chưa được cấp quyền báo đúng giờ.',
            style: TextStyle(fontSize: 13, height: 1.4),
          ),
          TextButton(
            onPressed: onAllow,
            style: TextButton.styleFrom(minimumSize: const Size(44, 44), foregroundColor: colors.accent),
            child: const Text('Cho phép báo đúng giờ', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
