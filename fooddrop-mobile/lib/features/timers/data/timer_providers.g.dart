// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Wall clock in epoch ms; tests override it.

@ProviderFor(nowMs)
final nowMsProvider = NowMsProvider._();

/// Wall clock in epoch ms; tests override it.

final class NowMsProvider extends $FunctionalProvider<NowMs, NowMs, NowMs>
    with $Provider<NowMs> {
  /// Wall clock in epoch ms; tests override it.
  NowMsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nowMsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nowMsHash();

  @$internal
  @override
  $ProviderElement<NowMs> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NowMs create(Ref ref) {
    return nowMs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NowMs value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NowMs>(value),
    );
  }
}

String _$nowMsHash() => r'1ab3f1cbcefe6f4293eba026f0e8fcc70b8a5ac5';

@ProviderFor(timerNotificationScheduler)
final timerNotificationSchedulerProvider =
    TimerNotificationSchedulerProvider._();

final class TimerNotificationSchedulerProvider
    extends
        $FunctionalProvider<
          TimerNotificationScheduler,
          TimerNotificationScheduler,
          TimerNotificationScheduler
        >
    with $Provider<TimerNotificationScheduler> {
  TimerNotificationSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timerNotificationSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timerNotificationSchedulerHash();

  @$internal
  @override
  $ProviderElement<TimerNotificationScheduler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TimerNotificationScheduler create(Ref ref) {
    return timerNotificationScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimerNotificationScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimerNotificationScheduler>(value),
    );
  }
}

String _$timerNotificationSchedulerHash() =>
    r'0044974e97a81a3de7e402fa2790b6538ee06629';

@ProviderFor(timersLocalStore)
final timersLocalStoreProvider = TimersLocalStoreProvider._();

final class TimersLocalStoreProvider
    extends
        $FunctionalProvider<
          TimersLocalStore,
          TimersLocalStore,
          TimersLocalStore
        >
    with $Provider<TimersLocalStore> {
  TimersLocalStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timersLocalStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timersLocalStoreHash();

  @$internal
  @override
  $ProviderElement<TimersLocalStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TimersLocalStore create(Ref ref) {
    return timersLocalStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimersLocalStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimersLocalStore>(value),
    );
  }
}

String _$timersLocalStoreHash() => r'27043f19160d14367bc0a47a8f5df7c68055ce22';

@ProviderFor(timers)
final timersProvider = TimersProvider._();

final class TimersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TimerEntry>>,
          List<TimerEntry>,
          Stream<List<TimerEntry>>
        >
    with $FutureModifier<List<TimerEntry>>, $StreamProvider<List<TimerEntry>> {
  TimersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timersHash();

  @$internal
  @override
  $StreamProviderElement<List<TimerEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TimerEntry>> create(Ref ref) {
    return timers(ref);
  }
}

String _$timersHash() => r'901f9a8c703f0dfc638681b641c614630d4990cf';

/// One shared clock for every timer on screen. Auto-disposes, so it only runs while a timer is visible.

@ProviderFor(ticker)
final tickerProvider = TickerProvider._();

/// One shared clock for every timer on screen. Auto-disposes, so it only runs while a timer is visible.

final class TickerProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// One shared clock for every timer on screen. Auto-disposes, so it only runs while a timer is visible.
  TickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tickerHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return ticker(ref);
  }
}

String _$tickerHash() => r'997e9b31a19e773290cdd7a1d7ca56a4857dfb1e';

/// Whether the OS will fire timer notifications at the exact second.

@ProviderFor(exactAlarmsAllowed)
final exactAlarmsAllowedProvider = ExactAlarmsAllowedProvider._();

/// Whether the OS will fire timer notifications at the exact second.

final class ExactAlarmsAllowedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the OS will fire timer notifications at the exact second.
  ExactAlarmsAllowedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exactAlarmsAllowedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exactAlarmsAllowedHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return exactAlarmsAllowed(ref);
  }
}

String _$exactAlarmsAllowedHash() =>
    r'1cf50f49d666d061ca438390b0c43b448dd0632c';

@ProviderFor(timerActions)
final timerActionsProvider = TimerActionsProvider._();

final class TimerActionsProvider
    extends $FunctionalProvider<TimerActions, TimerActions, TimerActions>
    with $Provider<TimerActions> {
  TimerActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timerActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timerActionsHash();

  @$internal
  @override
  $ProviderElement<TimerActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TimerActions create(Ref ref) {
    return timerActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimerActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimerActions>(value),
    );
  }
}

String _$timerActionsHash() => r'4edcd438c403be307829f63123e79b8dadeb1bcf';
