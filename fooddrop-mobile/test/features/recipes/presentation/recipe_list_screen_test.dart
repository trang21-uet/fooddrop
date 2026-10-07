import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/core/auth/auth_controller.dart';
import 'package:fooddrop/core/widgets/pill_chip.dart';
import 'package:fooddrop/features/recipes/data/recipe_providers.dart';
import 'package:fooddrop/features/recipes/data/sync_controller.dart';
import 'package:fooddrop/features/recipes/domain/rarity.dart';
import 'package:fooddrop/features/recipes/domain/recipe.dart';
import 'package:fooddrop/features/recipes/presentation/list/recipe_list_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../support/pump_app.dart';
import '../../../support/recipe_fixtures.dart';

class _FakeAuth extends AuthController {
  bool signedOut = false;

  @override
  Future<AuthSession?> build() async => const AuthSession(token: 't', name: 'Trang Nguyễn', email: 'trang@example.com');

  @override
  Future<void> signOut() async => signedOut = true;
}

class _FakeSync extends SyncController {
  _FakeSync(this.initial);

  final SyncState initial;

  @override
  SyncState build() => initial;

  @override
  Future<void> sync() async {}
}

void main() {
  final recipes = [
    domainRecipe(id: 'pho', title: 'Phở bò', rarity: Rarity.pink),
    domainRecipe(id: 'banh-mi', title: 'Bánh mì thịt nguội', rarity: Rarity.white, totalMinutes: 20),
    domainRecipe(id: 'kimchi', title: 'Canh kimchi', rarity: Rarity.blue, totalMinutes: 40),
  ];

  Future<void> openList(
    WidgetTester tester, {
    List<Recipe>? data,
    SyncState sync = const SyncState(),
    _FakeAuth? auth,
    List<RouteBase> extraRoutes = const [],
  }) async {
    await pumpRoutes(
      tester,
      initialLocation: '/recipes',
      overrides: <Override>[
        recipesProvider.overrideWith((ref) => Stream.value(data ?? recipes)),
        tagGroupsProvider.overrideWith((ref) => Stream.value(const <TagGroup>[])),
        syncControllerProvider.overrideWith(() => _FakeSync(sync)),
        authControllerProvider.overrideWith(() => auth ?? _FakeAuth()),
      ],
      routes: [
        GoRoute(path: '/recipes', builder: (context, state) => const RecipeListScreen()),
        ...extraRoutes,
      ],
    );
  }

  testWidgets('lists every recipe with its rarity, time and difficulty', (tester) async {
    await openList(tester);

    expect(find.text('Phở bò'), findsOneWidget);
    expect(find.text('Bánh mì thịt nguội'), findsOneWidget);
    expect(find.text('3 giờ · Độ khó 3/5'), findsOneWidget);
    expect(find.text('Sử thi'), findsWidgets);
    expect(find.text('TN'), findsOneWidget, reason: 'avatar initials');
  });

  testWidgets('rarity chips narrow the list and Tất cả restores it', (tester) async {
    await openList(tester);

    await tester.tap(find.widgetWithText(PillChip, 'Khá hiếm'));
    await tester.pumpAndSettle();
    expect(find.text('Canh kimchi'), findsOneWidget);
    expect(find.text('Phở bò'), findsNothing);

    await tester.tap(find.widgetWithText(PillChip, 'Tất cả'));
    await tester.pumpAndSettle();
    expect(find.text('Phở bò'), findsOneWidget);
  });

  testWidgets('search ignores diacritics and a miss offers to clear the filter', (tester) async {
    await openList(tester);

    await tester.enterText(find.byType(TextField), 'pho');
    await tester.pumpAndSettle();
    expect(find.text('Phở bò'), findsOneWidget);
    expect(find.text('Canh kimchi'), findsNothing);

    await tester.enterText(find.byType(TextField), 'khong-co-mon-nay');
    await tester.pumpAndSettle();
    expect(find.text('Không có công thức khớp'), findsOneWidget);

    await tester.tap(find.text('Xóa bộ lọc'));
    await tester.pumpAndSettle();
    expect(find.text('Không có công thức khớp'), findsNothing);
    expect(find.text('Phở bò'), findsOneWidget);
  });

  testWidgets('an empty library points at the add button', (tester) async {
    await openList(tester, data: const []);
    expect(find.text('Chưa có công thức nào'), findsOneWidget);
  });

  testWidgets('shows the cached list with a notice while offline', (tester) async {
    await openList(tester, sync: const SyncState(phase: SyncPhase.offline));

    expect(find.textContaining('Đang offline'), findsOneWidget);
    expect(find.text('Phở bò'), findsOneWidget, reason: 'recipes stay readable offline');
  });

  testWidgets('recipes with unsynced changes are marked', (tester) async {
    await openList(tester, data: [
      Recipe(
        id: 'local-1',
        title: 'Mới tạo',
        baseServings: 2,
        totalMinutes: 15,
        difficulty: 1,
        rarity: Rarity.white,
        createdAt: DateTime.utc(2026),
        isPending: true,
      ),
    ]);
    expect(find.byTooltip('Chưa đồng bộ'), findsOneWidget);
  });

  testWidgets('tapping a card opens the recipe and the + button opens the form', (tester) async {
    await openList(tester, extraRoutes: [
      GoRoute(path: '/recipes/new', builder: (context, state) => const Scaffold(body: Text('trang tạo mới'))),
      GoRoute(
        path: '/recipes/:id',
        builder: (context, state) => Scaffold(body: Text('chi tiết ${state.pathParameters['id']}')),
      ),
    ]);

    await tester.tap(find.text('Phở bò'));
    await tester.pumpAndSettle();
    expect(find.text('chi tiết pho'), findsOneWidget);

    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Thêm công thức'));
    await tester.pumpAndSettle();
    expect(find.text('trang tạo mới'), findsOneWidget);
  });

  testWidgets('the avatar opens the account sheet and signs out', (tester) async {
    final auth = _FakeAuth();
    await openList(tester, auth: auth);

    await tester.tap(find.text('TN'));
    await tester.pumpAndSettle();
    expect(find.text('trang@example.com'), findsOneWidget);

    await tester.tap(find.text('Đăng xuất'));
    await tester.pumpAndSettle();
    expect(auth.signedOut, isTrue);
  });
}
