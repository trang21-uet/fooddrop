import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/timers/domain/timer_math.dart';

TimerClock _clock(Map<String, dynamic> json) =>
    TimerClock(endsAtMs: json['endsAt'] as int, pausedRemainingMs: json['pausedRemainingMs'] as int?);

void main() {
  // Vectors shared with the web app; flutter test runs from the fooddrop-mobile folder.
  final cases = jsonDecode(File('../docs/fixtures/timer-math-cases.json').readAsStringSync()) as Map<String, dynamic>;
  List<Map<String, dynamic>> section(String name) => (cases[name] as List).cast<Map<String, dynamic>>();

  group('timer math (shared vectors)', () {
    for (final c in section('remaining')) {
      test('remaining at ${c['now']} -> ${c['expected']}', () {
        expect(timerRemainingMs(_clock(c['timer']), c['now'] as int), c['expected']);
      });
    }
    for (final c in section('pause')) {
      test('pause at ${c['now']}', () {
        expect(pauseTimer(_clock(c['timer']), c['now'] as int), _clock(c['expected']));
      });
    }
    for (final c in section('resume')) {
      test('resume at ${c['now']}', () {
        expect(resumeTimer(_clock(c['timer']), c['now'] as int), _clock(c['expected']));
      });
    }
    for (final c in section('add')) {
      test('add ${c['addMs']} at ${c['now']}', () {
        expect(addTimerMs(_clock(c['timer']), c['addMs'] as int, c['now'] as int), _clock(c['expected']));
      });
    }
  });

  test('formatCountdown rounds up and pads', () {
    expect(formatCountdown(0), '0:00');
    expect(formatCountdown(-500), '0:00');
    expect(formatCountdown(1), '0:01');
    expect(formatCountdown(83000), '1:23');
    expect(formatCountdown(600000), '10:00');
    expect(formatCountdown(3725000), '1:02:05');
  });
}
