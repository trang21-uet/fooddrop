import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/core/db/app_database.dart';
import 'package:fooddrop/features/recipes/data/recipe_local_store.dart';
import 'package:fooddrop/features/recipes/data/recipe_sync_service.dart';
import 'package:fooddrop/features/recipes/domain/recipe_draft.dart';

import '../../../support/fake_recipe_remote.dart';
import '../../../support/recipe_fixtures.dart';
import '../../../support/test_database.dart';

void main() {
  late AppDatabase db;
  late RecipeLocalStore store;
  late FakeRemote remote;
  late RecipeSyncService sync;

  const draft = RecipeDraft(title: 'Bánh mì', steps: [DraftStep(text: 'Nướng')]);

  setUp(() {
    db = openTestDatabase();
    store = RecipeLocalStore(db);
    remote = FakeRemote();
    sync = RecipeSyncService(store, remote);
  });
  tearDown(() => db.close());

  test('first sync pulls tags, summaries and the details of recipes it has none for', () async {
    remote.server['a'] = apiDetail(id: 'a');
    remote.server['b'] = apiDetail(id: 'b', title: 'Bún chả');

    await sync.sync();

    final recipes = await store.watchAll().first;
    expect(recipes.map((r) => r.id).toSet(), {'a', 'b'});
    expect(recipes.every((r) => r.hasDetail && r.ingredients.isNotEmpty), isTrue);
    expect((await store.watchTagGroups().first).single.slug, 'cuisine');
    expect((await store.watchUnits().first).map((u) => u.code), ['g', 'tbsp', 'fruit'], reason: 'the unit catalog is cached for offline pickers');
  });

  test('recipes whose photos use expiring signed URLs are re-fetched on every sync; public URLs are not', () async {
    remote.server['signed'] = apiDetail(id: 'signed', photoUrl: 'https://s3.example/a.jpg?X-Amz-Signature=abc');
    remote.server['public'] = apiDetail(id: 'public');
    await sync.sync();
    remote.calls.clear();

    await sync.sync();

    expect(remote.calls.where((call) => call.startsWith('get:')), ['get:signed']);
  });

  test('a recipe created offline is pushed on the next sync and swapped for the server copy', () async {
    final localId = await store.saveLocally(draft);

    await sync.sync();

    expect(remote.calls, contains('create:Bánh mì'));
    final recipes = await store.watchAll().first;
    expect(recipes.map((r) => r.id), ['server-1']);
    expect(recipes.single.isPending, isFalse);
    expect(await store.watchById(localId).first, isNull);
    expect(await store.pendingOps(), isEmpty);
  });

  test('push happens before pull so offline edits are not overwritten by the older server copy', () async {
    remote.server['r1'] = apiDetail(title: 'Phở cũ');
    await sync.sync();
    await store.saveLocally(draft.copyWith(title: 'Phở của tôi'), id: 'r1');

    await sync.sync();

    expect(remote.calls.indexOf('update:r1'), lessThan(remote.calls.lastIndexOf('list')));
    expect((await store.watchById('r1').first)!.title, 'Phở của tôi');
  });

  test('offline failures keep the queued change and the cached recipes', () async {
    remote.server['r1'] = apiDetail();
    await sync.sync();
    await store.saveLocally(draft, id: 'r1');

    remote.failWith = dioError(DioExceptionType.connectionError);
    await expectLater(sync.sync(), throwsA(isA<DioException>()));

    expect((await store.pendingOps()).map((op) => op.kind), ['update']);
    expect(await store.watchById('r1').first, isNotNull);
  });

  test('a recipe deleted on the phone is deleted on the server', () async {
    remote.server['r1'] = apiDetail();
    await sync.sync();
    await store.deleteLocally('r1');

    await sync.sync();

    expect(remote.server, isEmpty);
    expect(await store.watchAll().first, isEmpty);
  });

  test('recipes removed on the server disappear locally after a pull', () async {
    remote.server['r1'] = apiDetail();
    await sync.sync();
    remote.server.clear();

    await sync.sync();

    expect(await store.watchAll().first, isEmpty);
  });

  test('a change the server permanently rejects is dropped, counted and the server copy restored', () async {
    remote.server['r1'] = apiDetail(title: 'Server');
    await sync.sync();
    await store.saveLocally(draft.copyWith(title: 'Local'), id: 'r1');
    remote.failUpdateWith = dioError(DioExceptionType.badResponse, status: 400);

    final result = await sync.sync();

    expect(result.rejectedChanges, 1);
    expect(await store.pendingOps(), isEmpty, reason: 'the rejected op must not block the queue forever');
    expect((await store.watchById('r1').first)!.title, 'Server');
  });

  test('concurrent sync calls share one run', () async {
    remote.server['r1'] = apiDetail();
    await Future.wait([sync.sync(), sync.sync()]);
    expect(remote.calls.where((c) => c == 'list'), hasLength(1));
  });

  test('refreshDetail leaves recipes with unsynced edits alone', () async {
    remote.server['r1'] = apiDetail(title: 'Server');
    await sync.sync();
    await store.saveLocally(draft.copyWith(title: 'Local'), id: 'r1');
    remote.calls.clear();

    await sync.refreshDetail('r1');

    expect(remote.calls, isEmpty);
    expect((await store.watchById('r1').first)!.title, 'Local');
  });
}
