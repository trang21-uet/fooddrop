import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/timers/data/timer_providers.dart';
import '../api/api_client_provider.dart';
import '../db/database_provider.dart';
import 'auth_remote.dart';
import 'session_storage.dart';

export 'session_storage.dart' show AuthSession;

part 'auth_controller.g.dart';

/// Holds the signed-in session (null when signed out). Launch is offline-friendly: the stored
/// session is trusted, and a 401 from any request signs the user out via [expireSession].
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<AuthSession?> build() async {
    final session = await ref.read(sessionStorageProvider).read();
    if (session != null) _applyToken(session.token);
    return session;
  }

  AuthRemote get _remote => AuthRemote(ref.read(apiClientProvider).dio);

  Future<void> signIn({required String email, required String password}) async {
    await _store(await _remote.signIn(email: email, password: password));
  }

  Future<void> signUp({required String name, required String email, required String password}) async {
    await _store(await _remote.signUp(name: name, email: email, password: password));
  }

  Future<void> signOut() async {
    final token = state.value?.token;
    if (token != null) {
      // Best effort: the local sign-out must succeed even when the network is down.
      try {
        await _remote.signOut(token);
      } catch (_) {}
    }
    await expireSession();
  }

  /// Clears the token and every locally cached recipe so the next account never sees them.
  Future<void> expireSession() async {
    if (state.value == null) return;
    ref.read(apiClientProvider).removeBearerAuth(bearerSchemeName);
    await ref.read(sessionStorageProvider).clear();
    // Scheduled timer notifications would otherwise still fire for the account that just left.
    await ref.read(timerActionsProvider).cancelAllNotifications();
    await ref.read(appDatabaseProvider).wipe();
    state = const AsyncData(null);
  }

  Future<void> _store(AuthSession session) async {
    await ref.read(sessionStorageProvider).write(session);
    _applyToken(session.token);
    state = AsyncData(session);
  }

  void _applyToken(String token) => ref.read(apiClientProvider).setBearerAuth(bearerSchemeName, token);
}
