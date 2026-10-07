import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_storage.g.dart';

class AuthSession {
  const AuthSession({required this.token, required this.name, required this.email});

  final String token;
  final String name;
  final String email;

  /// Two-letter avatar text: first letters of the first and last words of the name.
  String get initials {
    final words = name.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
    if (words.isEmpty) return email.isEmpty ? '?' : email[0].toUpperCase();
    if (words.length == 1) return words.first[0].toUpperCase();
    return (words.first[0] + words.last[0]).toUpperCase();
  }
}

/// Where the bearer token lives. Tokens are never kept anywhere but secure storage.
abstract class SessionStorage {
  Future<AuthSession?> read();
  Future<void> write(AuthSession session);
  Future<void> clear();
}

class SecureSessionStorage implements SessionStorage {
  const SecureSessionStorage([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'session_token';
  static const _nameKey = 'session_name';
  static const _emailKey = 'session_email';

  @override
  Future<AuthSession?> read() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null) return null;
    return AuthSession(
      token: token,
      name: await _storage.read(key: _nameKey) ?? '',
      email: await _storage.read(key: _emailKey) ?? '',
    );
  }

  @override
  Future<void> write(AuthSession session) async {
    await _storage.write(key: _tokenKey, value: session.token);
    await _storage.write(key: _nameKey, value: session.name);
    await _storage.write(key: _emailKey, value: session.email);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _nameKey);
    await _storage.delete(key: _emailKey);
  }
}

@Riverpod(keepAlive: true)
SessionStorage sessionStorage(Ref ref) => const SecureSessionStorage();
