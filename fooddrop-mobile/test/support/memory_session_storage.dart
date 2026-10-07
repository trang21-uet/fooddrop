import 'package:fooddrop/core/auth/session_storage.dart';

class MemorySessionStorage implements SessionStorage {
  MemorySessionStorage([this.session]);

  AuthSession? session;

  @override
  Future<AuthSession?> read() async => session;

  @override
  Future<void> write(AuthSession session) async => this.session = session;

  @override
  Future<void> clear() async => session = null;
}
