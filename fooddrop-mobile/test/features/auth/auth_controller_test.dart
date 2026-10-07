import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/core/api/api_client_provider.dart';
import 'package:fooddrop/core/auth/auth_controller.dart';
import 'package:fooddrop/core/auth/auth_remote.dart';
import 'package:fooddrop/core/auth/session_storage.dart';
import 'package:fooddrop/core/db/app_database.dart';
import 'package:fooddrop/core/db/database_provider.dart';

import '../../support/memory_session_storage.dart';

import '../../support/stub_http_adapter.dart';
import '../../support/test_database.dart';

void main() {
  late AppDatabase db;
  late MemorySessionStorage storage;
  late StubHttpAdapter adapter;

  const signedToken = 'tok.sig';

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        sessionStorageProvider.overrideWithValue(storage),
        apiClientProvider.overrideWithValue(stubApi(adapter)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    db = openTestDatabase();
    storage = MemorySessionStorage();
    adapter = StubHttpAdapter({
      'POST /api/auth/sign-in/email': (
        status: 200,
        body: {'token': 'tok', 'user': {'name': 'Trang Nguyễn', 'email': 'trang@example.com'}},
        headers: {'set-auth-token': signedToken},
      ),
      'POST /api/auth/sign-up/email': (
        status: 200,
        body: {'token': 'tok', 'user': {'name': 'Mới', 'email': 'moi@example.com'}},
        headers: {'set-auth-token': signedToken},
      ),
      'POST /api/auth/sign-out': (status: 200, body: {'success': true}, headers: {}),
    });
  });
  tearDown(() => db.close());

  test('starts signed out when nothing is stored', () async {
    final container = makeContainer();
    expect(await container.read(authControllerProvider.future), isNull);
  });

  test('restores a stored session without a network call', () async {
    storage.session = const AuthSession(token: signedToken, name: 'Trang', email: 't@example.com');
    final container = makeContainer();

    final session = await container.read(authControllerProvider.future);

    expect(session!.token, signedToken);
    expect(adapter.requests, isEmpty);
  });

  test('sign in keeps the signed bearer token from set-auth-token in secure storage', () async {
    final container = makeContainer();
    await container.read(authControllerProvider.future);

    await container.read(authControllerProvider.notifier).signIn(email: 't@example.com', password: 'secret-123');

    final session = container.read(authControllerProvider).value!;
    expect(session.token, signedToken);
    expect(session.initials, 'TN');
    expect(storage.session!.token, signedToken);
    expect(adapter.requests.single.data, {'email': 't@example.com', 'password': 'secret-123'});
  });

  test('later API calls carry the bearer token', () async {
    adapter.routes['GET /recipes'] = (status: 200, body: {'items': [], 'nextCursor': null}, headers: {});
    final container = makeContainer();
    await container.read(authControllerProvider.future);
    await container.read(authControllerProvider.notifier).signIn(email: 't@example.com', password: 'secret-123');

    await container.read(apiClientProvider).getRecipesApi().recipesControllerList();

    expect(adapter.requests.last.headers['Authorization'], 'Bearer $signedToken');
  });

  test('sign up sends the display name', () async {
    final container = makeContainer();
    await container.read(authControllerProvider.future);

    await container
        .read(authControllerProvider.notifier)
        .signUp(name: 'Mới', email: 'moi@example.com', password: 'secret-1234');

    expect(adapter.requests.single.data['name'], 'Mới');
    expect(container.read(authControllerProvider).value!.email, 'moi@example.com');
  });

  test('a rejected sign in surfaces a Vietnamese message and stores nothing', () async {
    adapter.routes['POST /api/auth/sign-in/email'] = (
      status: 401,
      body: {'code': 'INVALID_EMAIL_OR_PASSWORD', 'message': 'Invalid email or password'},
      headers: {},
    );
    final container = makeContainer();
    await container.read(authControllerProvider.future);

    await expectLater(
      container.read(authControllerProvider.notifier).signIn(email: 't@example.com', password: 'wrong-pass'),
      throwsA(isA<AuthException>().having((e) => e.message, 'message', 'Email hoặc mật khẩu không đúng.')),
    );
    expect(storage.session, isNull);
    expect(container.read(authControllerProvider).value, isNull);
  });

  test('sign out clears the token and every cached recipe', () async {
    storage.session = const AuthSession(token: signedToken, name: 'Trang', email: 't@example.com');
    final container = makeContainer();
    await container.read(authControllerProvider.future);
    await db.into(db.tags).insert(TagsCompanion.insert(
          id: const Value(1),
          dimensionId: 1,
          dimensionSlug: 'cuisine',
          dimensionLabel: 'Ẩm thực',
          slug: 'vietnamese',
          label: 'Việt Nam',
        ));

    await container.read(authControllerProvider.notifier).signOut();

    expect(container.read(authControllerProvider).value, isNull);
    expect(storage.session, isNull);
    expect(await db.select(db.tags).get(), isEmpty);
    expect(adapter.requests.map((r) => r.path), contains('/api/auth/sign-out'));
  });

  test('sign out still works offline', () async {
    storage.session = const AuthSession(token: signedToken, name: 'Trang', email: 't@example.com');
    adapter.routes.remove('POST /api/auth/sign-out');
    final container = makeContainer();
    await container.read(authControllerProvider.future);

    await container.read(authControllerProvider.notifier).signOut();

    expect(storage.session, isNull);
  });
}
