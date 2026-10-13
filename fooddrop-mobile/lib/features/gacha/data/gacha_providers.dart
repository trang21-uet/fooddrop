import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_client_provider.dart';
import '../domain/gacha_case.dart';
import '../domain/gacha_spin.dart';
import 'gacha_remote.dart';
import 'reel_image_preloader.dart';
import 'tick_sound_player.dart';

part 'gacha_providers.g.dart';

@Riverpod(keepAlive: true)
GachaRemote gachaRemote(Ref ref) => GachaRemote(ref.watch(apiClientProvider));

/// Tests override this: flutter_soloud needs the native audio engine.
@Riverpod(keepAlive: true)
ReelSoundPlayer reelSoundPlayer(Ref ref) => SoLoudReelSoundPlayer();

@Riverpod(keepAlive: true)
ReelImagePreloader reelImagePreloader(Ref ref) => const ReelImagePreloader();

/// How long the reel spins; tests override it to keep widget tests short.
@Riverpod(keepAlive: true)
Duration spinDuration(Ref ref) => const Duration(seconds: 7);

/// The cases with what each holds; the picker and the reel page share it.
@riverpod
Future<List<GachaCaseSummary>> gachaCases(Ref ref) => ref.watch(gachaRemoteProvider).cases();

/// Latest spins. Invalidated after the reel lands, never before, so it cannot spoil a result.
@riverpod
Future<List<SpinHistoryEntry>> spinHistory(Ref ref) => ref.watch(gachaRemoteProvider).history();
