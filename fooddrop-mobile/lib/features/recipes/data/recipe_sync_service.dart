import 'dart:async';
import 'dart:convert';

import 'package:fooddrop_api/fooddrop_api.dart' as api;

import '../../../core/api/api_error.dart';
import '../../../core/db/app_database.dart';
import 'recipe_local_store.dart';
import 'recipe_remote.dart';

const _detailConcurrency = 4;

class SyncResult {
  const SyncResult({this.rejectedChanges = 0});

  /// Queued edits the server permanently refused (validation, recipe gone); they were dropped
  /// and the server's version restored by the pull.
  final int rejectedChanges;
}

/// Push the outbox, then pull. Pushing first means a recipe edited offline is never overwritten
/// by an older server copy: the last write to reach the server wins.
class RecipeSyncService {
  RecipeSyncService(this._store, this._remote);

  final RecipeLocalStore _store;
  final RecipeRemote _remote;
  Future<SyncResult>? _running;

  /// Runs one sync at a time; callers during a run share its result. Throws on network failure
  /// (callers treat [isOffline] errors as "try again later").
  Future<SyncResult> sync() => _running ??= _run().whenComplete(() => _running = null);

  Future<SyncResult> _run() async {
    final rejected = await _push();
    await _pull();
    return SyncResult(rejectedChanges: rejected);
  }

  Future<int> _push() async {
    var rejected = 0;
    for (final op in await _store.pendingOps()) {
      try {
        await _replay(op);
      } catch (error) {
        if (!isPermanentRejection(error)) rethrow;
        await _store.removeOp(op.id);
        rejected++;
      }
    }
    return rejected;
  }

  Future<void> _replay(OutboxRow op) async {
    switch (op.kind) {
      case 'create':
        final detail = await _remote.create(_parseInput(op.payloadJson!));
        await _store.replaceLocal(op.recipeId, detail, op.id);
      case 'update':
        final detail = await _remote.update(op.recipeId, _parseInput(op.payloadJson!));
        await _store.upsertDetail(detail);
        await _store.removeOp(op.id);
      case 'delete':
        await _remote.delete(op.recipeId);
        await _store.removeOp(op.id);
      default:
        throw StateError('Unknown outbox kind ${op.kind}');
    }
  }

  api.RecipeInput _parseInput(String json) => api.RecipeInput.fromJson(jsonDecode(json) as Map<String, dynamic>);

  Future<void> _pull() async {
    await _store.replaceTags(await _remote.tags());

    final summaries = await _remote.listAll();
    final pending = await _store.pendingRecipeIds();
    await _store.applySummaries(summaries, skipIds: pending);
    await _store.removeMissing({for (final item in summaries) item.id}, keepIds: pending);

    await _fetchMissingDetails(pending);
  }

  /// Details (steps, ingredients) are what make a recipe usable offline. Existing ones are
  /// refreshed lazily when opened; only recipes without any detail are fetched here.
  Future<void> _fetchMissingDetails(Set<String> pending) async {
    final ids = (await _store.idsMissingDetail()).where((id) => !pending.contains(id)).toList();
    for (var start = 0; start < ids.length; start += _detailConcurrency) {
      final batch = ids.skip(start).take(_detailConcurrency);
      await Future.wait(batch.map(refreshDetail));
    }
  }

  /// Re-fetches one recipe unless it has unsynced local edits.
  Future<void> refreshDetail(String id) async {
    if (isLocalId(id) || (await _store.pendingRecipeIds()).contains(id)) return;
    try {
      await _store.upsertDetail(await _remote.get(id));
    } catch (error) {
      // Deleted elsewhere: the next full pull removes it. Anything else is the caller's problem.
      if (!isPermanentRejection(error)) rethrow;
    }
  }
}
