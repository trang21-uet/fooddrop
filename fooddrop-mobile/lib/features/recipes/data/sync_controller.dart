import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_error.dart';
import '../../../core/auth/auth_controller.dart';
import 'recipe_providers.dart';

part 'sync_controller.g.dart';

enum SyncPhase { idle, syncing, offline, failed }

class SyncState {
  const SyncState({this.phase = SyncPhase.idle, this.rejectedChanges = 0});

  final SyncPhase phase;

  /// Queued edits the server refused in the last run, so the UI can tell the user.
  final int rejectedChanges;
}

/// Runs a sync on sign-in and whenever asked (pull-to-refresh, app resume, after a local edit).
@Riverpod(keepAlive: true)
class SyncController extends _$SyncController {
  @override
  SyncState build() {
    final signedIn = ref.watch(authControllerProvider).value != null;
    if (signedIn) Future.microtask(sync);
    return const SyncState();
  }

  Future<void> sync() async {
    if (ref.read(authControllerProvider).value == null) return;
    state = const SyncState(phase: SyncPhase.syncing);
    try {
      final result = await ref.read(recipeSyncServiceProvider).sync();
      if (ref.mounted) state = SyncState(rejectedChanges: result.rejectedChanges);
    } catch (error) {
      if (ref.mounted) state = SyncState(phase: isOffline(error) ? SyncPhase.offline : SyncPhase.failed);
    }
  }
}
