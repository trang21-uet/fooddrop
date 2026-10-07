
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/core/api/api_client_provider.dart';
import 'package:fooddrop/core/auth/auth_remote.dart';
import 'package:fooddrop/features/recipes/data/recipe_local_store.dart';
import 'package:fooddrop/features/recipes/data/recipe_remote.dart';
import 'package:fooddrop/features/recipes/data/recipe_sync_service.dart';
import 'package:fooddrop/features/recipes/domain/recipe_draft.dart';
import 'package:fooddrop_api/fooddrop_api.dart';

import '../support/test_database.dart';

/// End-to-end against a running backend (`docker compose up -d` + `pnpm start:dev`, seeded).
/// Skipped when nothing answers at `API_BASE_URL`, like the web Playwright spec.
void main() {
  late bool backendUp;
  late Dio dio;

  setUpAll(() async {
    dio = Dio(BaseOptions(baseUrl: apiBaseUrl, connectTimeout: const Duration(seconds: 2)));
    try {
      await dio.get<void>('/health');
      backendUp = true;
    } on DioException {
      backendUp = false;
    }
  });

  test('sign up, create offline, sync, edit, delete against the real API', () async {
    if (!backendUp) {
      markTestSkipped('Backend not reachable at $apiBaseUrl');
      return;
    }
    final email = 'mobile-e2e-${DateTime.now().microsecondsSinceEpoch}@example.com';
    final session = await AuthRemote(dio).signUp(name: 'Mobile E2E', email: email, password: 'e2e-pass-1234');
    final api = FooddropApi(dio: Dio(BaseOptions(baseUrl: apiBaseUrl)))..setBearerAuth(bearerSchemeName, session.token);
    final remote = RecipeRemote(api);
    final db = openTestDatabase();
    addTearDown(db.close);
    final store = RecipeLocalStore(db);
    final sync = RecipeSyncService(store, remote);

    // First launch: tags arrive, library is empty.
    await sync.sync();
    expect(await store.watchTagGroups().first, isNotEmpty, reason: 'seeded tag dimensions');
    expect(await store.watchAll().first, isEmpty);

    // Created while "offline": only on the device until the next sync.
    final ingredient = (await remote.searchIngredients('hành')).first;
    final localId = await store.saveLocally(RecipeDraft(
      title: 'E2E bún chả',
      totalMinutes: 40,
      difficulty: 2,
      steps: const [DraftStep(text: 'Nướng thịt', timerMinutes: 10)],
      ingredients: [
        DraftIngredient(ingredientId: ingredient.id, name: ingredient.name, quantityText: '1 1/2', unitText: 'g'),
      ],
    ));
    expect(isLocalId(localId), isTrue);

    await sync.sync();

    final created = (await store.watchAll().first).single;
    expect(isLocalId(created.id), isFalse, reason: 'swapped for the server id');
    expect(created.isPending, isFalse);
    expect(created.rarity.apiValue, 'blue', reason: 'server-computed rarity for 40 min / difficulty 2');
    expect(created.ingredients.single.quantity, 1.5, reason: 'server normalized "1 1/2"');
    expect(created.steps!.single.timerSeconds, 600);

    // Edit on the device, push, and the server copy matches.
    await store.saveLocally(RecipeDraft.fromRecipe(created).copyWith(title: 'E2E bún chả (sửa)'), id: created.id);
    await sync.sync();
    expect((await remote.get(created.id)).title, 'E2E bún chả (sửa)');

    // Delete on the device, push, and it is gone everywhere.
    await store.deleteLocally(created.id);
    await sync.sync();
    expect(await store.watchAll().first, isEmpty);
    expect(await remote.listAll(), isEmpty);
  });
}
