import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_client_provider.dart';
import '../../../core/db/database_provider.dart';
import '../domain/recipe.dart';
import '../domain/recipe_draft.dart';
import '../domain/recipe_unit.dart';
import 'recipe_local_store.dart';
import 'recipe_remote.dart';
import 'recipe_sync_service.dart';
import 'sync_controller.dart';

part 'recipe_providers.g.dart';

@Riverpod(keepAlive: true)
RecipeLocalStore recipeLocalStore(Ref ref) => RecipeLocalStore(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
RecipeRemote recipeRemote(Ref ref) => RecipeRemote(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
RecipeSyncService recipeSyncService(Ref ref) =>
    RecipeSyncService(ref.watch(recipeLocalStoreProvider), ref.watch(recipeRemoteProvider));

@riverpod
Stream<List<Recipe>> recipes(Ref ref) => ref.watch(recipeLocalStoreProvider).watchAll();

@riverpod
Stream<Recipe?> recipe(Ref ref, String id) => ref.watch(recipeLocalStoreProvider).watchById(id);

@riverpod
Stream<List<TagGroup>> tagGroups(Ref ref) => ref.watch(recipeLocalStoreProvider).watchTagGroups();

/// The unit catalog for pickers, from the local cache so it works offline.
@riverpod
Stream<List<RecipeUnit>> units(Ref ref) => ref.watch(recipeLocalStoreProvider).watchUnits();

/// User-initiated changes. They land in Drift first and sync in the background.
class RecipeActions {
  RecipeActions(this._ref);

  final Ref _ref;

  RecipeLocalStore get _store => _ref.read(recipeLocalStoreProvider);

  /// Returns the id of the saved recipe (a local id until the first sync of a new recipe).
  Future<String> save(RecipeDraft draft, {String? id}) async {
    final savedId = await _store.saveLocally(draft, id: id);
    unawaited(_ref.read(syncControllerProvider.notifier).sync());
    return savedId;
  }

  Future<void> delete(String id) async {
    await _store.deleteLocally(id);
    unawaited(_ref.read(syncControllerProvider.notifier).sync());
  }

  /// Stale-while-revalidate for the detail screen; offline failures are fine, the cached copy shows.
  Future<void> refreshDetail(String id) => _ref.read(recipeSyncServiceProvider).refreshDetail(id);
}

@riverpod
RecipeActions recipeActions(Ref ref) => RecipeActions(ref);
