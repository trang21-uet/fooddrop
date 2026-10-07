import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/core/api/api_client_provider.dart';
import 'package:fooddrop/core/auth/session_storage.dart';
import 'package:fooddrop/core/db/database_provider.dart';
import 'package:fooddrop/features/auth/presentation/login_screen.dart';
import 'package:fooddrop/features/auth/presentation/register_screen.dart';
import 'package:go_router/go_router.dart';

import '../../support/memory_session_storage.dart';
import '../../support/pump_app.dart';
import '../../support/stub_http_adapter.dart';
import '../../support/test_database.dart';

void main() {
  late StubHttpAdapter adapter;
  late MemorySessionStorage storage;

  setUp(() {
    storage = MemorySessionStorage();
    adapter = StubHttpAdapter({
      'POST /api/auth/sign-in/email': (
        status: 200,
        body: {'user': {'name': 'Trang', 'email': 'trang@example.com'}},
        headers: {'set-auth-token': 'tok.sig'},
      ),
    });
  });

  Future<void> openAuth(WidgetTester tester, {String location = '/login'}) async {
    final db = openTestDatabase();
    addTearDown(db.close);
    await pumpRoutes(
      tester,
      initialLocation: location,
      overrides: <Override>[
        appDatabaseProvider.overrideWithValue(db),
        sessionStorageProvider.overrideWithValue(storage),
        apiClientProvider.overrideWithValue(stubApi(adapter)),
      ],
      routes: [
        GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
        GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      ],
    );
  }

  testWidgets('login validates before calling the server', (tester) async {
    await openAuth(tester);

    await tester.tap(find.widgetWithText(InkWell, 'Đăng nhập'));
    await tester.pumpAndSettle();

    expect(find.text('Nhập email'), findsOneWidget);
    expect(find.text('Nhập mật khẩu'), findsOneWidget);
    expect(adapter.requests, isEmpty);

    await tester.enterText(find.byType(TextFormField).first, 'khong-phai-email');
    await tester.tap(find.widgetWithText(InkWell, 'Đăng nhập'));
    await tester.pumpAndSettle();
    expect(find.text('Email không hợp lệ.'), findsOneWidget);
  });

  testWidgets('a valid login stores the session', (tester) async {
    await openAuth(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'trang@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret-1234');
    await tester.tap(find.widgetWithText(InkWell, 'Đăng nhập'));
    await tester.pumpAndSettle();

    expect(storage.session!.token, 'tok.sig');
    expect(adapter.requests.single.data, {'email': 'trang@example.com', 'password': 'secret-1234'});
  });

  testWidgets('wrong credentials show the translated server message', (tester) async {
    adapter.routes['POST /api/auth/sign-in/email'] = (
      status: 401,
      body: {'code': 'INVALID_EMAIL_OR_PASSWORD', 'message': 'Invalid email or password'},
      headers: {},
    );
    await openAuth(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'trang@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrong-pass');
    await tester.tap(find.widgetWithText(InkWell, 'Đăng nhập'));
    await tester.pumpAndSettle();

    expect(find.text('Email hoặc mật khẩu không đúng.'), findsOneWidget);
    expect(storage.session, isNull);
  });

  testWidgets('the password can be revealed', (tester) async {
    await openAuth(tester);
    EditableText password() => tester.widget<EditableText>(find.byType(EditableText).at(1));

    expect(password().obscureText, isTrue);
    await tester.tap(find.byTooltip('Hiện mật khẩu'));
    await tester.pump();
    expect(password().obscureText, isFalse);
  });

  testWidgets('register asks for a name and an 8+ character password', (tester) async {
    await openAuth(tester, location: '/register');

    await tester.enterText(find.byType(TextFormField).at(1), 'moi@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'abc123');
    await tester.tap(find.widgetWithText(InkWell, 'Tạo tài khoản'));
    await tester.pumpAndSettle();

    expect(find.text('Nhập tên hiển thị'), findsOneWidget);
    expect(find.text('Mật khẩu cần ít nhất 8 ký tự.'), findsOneWidget);
    expect(adapter.requests, isEmpty);
  });
}
