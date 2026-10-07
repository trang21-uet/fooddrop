import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/app/food_drop_app.dart';
import 'package:fooddrop/core/api/api_client_provider.dart';
import 'package:fooddrop/core/auth/auth_controller.dart';
import 'package:fooddrop/core/auth/session_storage.dart';
import 'package:fooddrop/core/db/database_provider.dart';
import 'package:fooddrop/features/recipes/data/sync_controller.dart';
import 'package:google_fonts/google_fonts.dart';

import '../support/memory_session_storage.dart';
import '../support/stub_http_adapter.dart';
import '../support/test_database.dart';

class _IdleSync extends SyncController {
  @override
  SyncState build() => const SyncState();

  @override
  Future<void> sync() async {}
}

void main() {
  late MemorySessionStorage storage;
  late StubHttpAdapter adapter;

  setUp(() {
    storage = MemorySessionStorage();
    adapter = StubHttpAdapter({
      'POST /api/auth/sign-in/email': (
        status: 200,
        body: {'user': {'name': 'Trang', 'email': 'trang@example.com'}},
        headers: {'set-auth-token': 'tok.sig'},
      ),
      'POST /api/auth/sign-out': (status: 200, body: {'success': true}, headers: {}),
    });
  });

  Future<ProviderContainer> bootApp(WidgetTester tester) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = openTestDatabase();
    addTearDown(db.close);
    final container = ProviderContainer(overrides: <Override>[
      appDatabaseProvider.overrideWithValue(db),
      sessionStorageProvider.overrideWithValue(storage),
      apiClientProvider.overrideWithValue(stubApi(adapter)),
      syncControllerProvider.overrideWith(_IdleSync.new),
    ]);
    addTearDown(container.dispose);
    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const FoodDropApp()));
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('a signed-out launch lands on the login screen', (tester) async {
    await bootApp(tester);

    expect(find.text('Mở hộp, nhận món, vào bếp.'), findsOneWidget);
    expect(find.text('Công thức'), findsNothing);
  });

  testWidgets('a stored session skips login and opens the recipe list', (tester) async {
    storage.session = const AuthSession(token: 'tok.sig', name: 'Trang Nguyễn', email: 'trang@example.com');

    await bootApp(tester);

    expect(find.text('Công thức'), findsOneWidget);
    expect(find.text('TN'), findsOneWidget);
    expect(adapter.requests, isEmpty, reason: 'launch must not need the network');
  });

  testWidgets('signing in moves to the list and signing out returns to login', (tester) async {
    final container = await bootApp(tester);

    final auth = container.read(authControllerProvider.notifier);
    // Real HTTP-stack futures need real time, which the widget test's fake clock does not advance.
    await tester.runAsync(() => auth.signIn(email: 'trang@example.com', password: 'secret-1234'));
    await tester.pumpAndSettle();
    expect(find.text('Công thức'), findsOneWidget);

    await tester.runAsync(auth.signOut);
    await tester.pumpAndSettle();
    expect(find.text('Mở hộp, nhận món, vào bếp.'), findsOneWidget);
    // Leaving the list cancels Drift's stream queries, which closes them on a zero-length timer.
    await tester.pump(Duration.zero);
  });

  testWidgets('the register screen is reachable from login and returns', (tester) async {
    await bootApp(tester);

    await tester.tap(find.text('Tạo tài khoản'));
    await tester.pumpAndSettle();
    expect(find.text('Chỉ mất chưa đầy một phút.'), findsOneWidget);

    await tester.tap(find.text('Đăng nhập'));
    await tester.pumpAndSettle();
    expect(find.text('Mở hộp, nhận món, vào bếp.'), findsOneWidget);
  });
}
