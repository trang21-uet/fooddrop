import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/parser/data/parse_cooldown.dart';
import 'package:fooddrop/features/parser/domain/parse_error_message.dart';
import 'package:fooddrop/features/timers/data/timer_providers.dart' show nowMsProvider;

DioException _http(int status, [Object? data]) {
  final options = RequestOptions(path: '/parser/jobs');
  return DioException(requestOptions: options, response: Response(requestOptions: options, statusCode: status, data: data));
}

Map<String, dynamic> _limit(String code, {int? retryAfterSeconds}) => {
      'statusCode': 429,
      'code': code,
      'message': 'x',
      'retryAfterSeconds': ?retryAfterSeconds,
    };

void main() {
  group('ParseCooldown', () {
    test('is idle until an import starts, then runs for the given length from "now"', () {
      var now = 1000000;
      final container = ProviderContainer(overrides: [nowMsProvider.overrideWithValue(() => now)]);
      addTearDown(container.dispose);

      expect(parseCooldownSecondsLeft(container.read(parseCooldownProvider), now), 0);

      container.read(parseCooldownProvider.notifier).start(const Duration(seconds: 60));
      expect(parseCooldownSecondsLeft(container.read(parseCooldownProvider), now), 60);
      now += 59001;
      expect(parseCooldownSecondsLeft(container.read(parseCooldownProvider), now), 1);
      now += 999;
      expect(parseCooldownSecondsLeft(container.read(parseCooldownProvider), now), 0);
    });

    test('a zero-length cooldown (off on the server) does not block', () {
      final container = ProviderContainer(overrides: [nowMsProvider.overrideWithValue(() => 5000)]);
      addTearDown(container.dispose);

      container.read(parseCooldownProvider.notifier).start(Duration.zero);
      expect(parseCooldownSecondsLeft(container.read(parseCooldownProvider), 5000), 0);
    });

    test('takes the wait the server reports', () {
      final container = ProviderContainer(overrides: [nowMsProvider.overrideWithValue(() => 5000)]);
      addTearDown(container.dispose);

      container.read(parseCooldownProvider.notifier).start(const Duration(seconds: 25));
      expect(parseCooldownSecondsLeft(container.read(parseCooldownProvider), 5000), 25);
    });
  });

  group('retryAfterSecondsOf', () {
    test('reads the seconds from a 429 body', () {
      expect(retryAfterSecondsOf(_http(429, _limit('parse_cooldown', retryAfterSeconds: 42))), 42);
    });

    test('ignores other statuses, missing or invalid values', () {
      expect(retryAfterSecondsOf(_http(429)), isNull);
      expect(retryAfterSecondsOf(_http(429, _limit('parse_daily_quota'))), isNull);
      expect(retryAfterSecondsOf(_http(429, _limit('parse_cooldown', retryAfterSeconds: 0))), isNull);
      expect(retryAfterSecondsOf(_http(429, {'retryAfterSeconds': 42})), isNull);
      expect(retryAfterSecondsOf(_http(503, _limit('parse_cooldown', retryAfterSeconds: 42))), isNull);
      expect(retryAfterSecondsOf(StateError('x')), isNull);
    });

    test('the daily-quota 429 gets its own message', () {
      expect(describeImportStartError(_http(429, _limit('parse_daily_quota'))), contains('quá nhiều'));
    });
  });
}
