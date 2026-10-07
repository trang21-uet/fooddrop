import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:fooddrop_api/fooddrop_api.dart' as api;

import '../../../core/db/app_database.dart';
import '../domain/recipe.dart';
import '../domain/recipe_draft.dart';
import 'recipe_mappers.dart';

const localIdPrefix = 'local-';

bool isLocalId(String id) => id.startsWith(localIdPrefix);

/// All Drift reads and writes for recipes, tags and the outbox.
class RecipeLocalStore {
  RecipeLocalStore(this._db);

  final AppDatabase _db;

  // ---- Reads --------------------------------------------------------------------------------

  Stream<List<Recipe>> watchAll() => _reload(_loadAll);

  Stream<Recipe?> watchById(String id) => _reload(() async => (await _loadAll()).where((r) => r.id == id).firstOrNull);

  /// Re-runs [load] whenever a recipe-related table changes.
  Stream<T> _reload<T>(Future<T> Function() load) async* {
    yield await load();
    final changes = _db.tableUpdates(
      TableUpdateQuery.onAllTables([_db.recipes, _db.recipeIngredients, _db.recipeTags, _db.outbox]),
    );
    await for (final _ in changes) {
      yield await load();
    }
  }

  Future<List<Recipe>> _loadAll() async {
    final rows = await (_db.select(_db.recipes)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
    final ingredients = await (_db.select(_db.recipeIngredients)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
    final tags = await _db.select(_db.recipeTags).get();
    final pending = await pendingRecipeIds();
    return [
      for (final row in rows)
        recipeFromRows(
          row,
          ingredients: ingredients.where((i) => i.recipeId == row.id).toList(),
          tagIds: [for (final t in tags) if (t.recipeId == row.id) t.tagId],
          isPending: pending.contains(row.id),
        ),
    ];
  }

  Stream<List<TagGroup>> watchTagGroups() => _db.select(_db.tags).watch().map(_groupTags);

  List<TagGroup> _groupTags(List<TagRow> rows) {
    final byDimension = <int, List<TagRow>>{};
    for (final row in rows) {
      byDimension.putIfAbsent(row.dimensionId, () => []).add(row);
    }
    return [
      for (final entry in byDimension.entries)
        TagGroup(
          id: entry.key,
          slug: entry.value.first.dimensionSlug,
          label: entry.value.first.dimensionLabel,
          tags: [
            for (final row in entry.value)
              Tag(id: row.id, dimensionId: row.dimensionId, slug: row.slug, label: row.label),
          ],
        ),
    ]..sort((a, b) => a.id.compareTo(b.id));
  }

  /// Ingredients already used by synced recipes: the offline fallback for the ingredient picker.
  Future<List<RecipeIngredientRow>> knownIngredients() async {
    final rows = await _db.select(_db.recipeIngredients).get();
    return {for (final row in rows) row.ingredientId: row}.values.toList();
  }

  Future<Set<String>> pendingRecipeIds() async =>
      (await _db.select(_db.outbox).get()).map((op) => op.recipeId).toSet();

  Future<List<OutboxRow>> pendingOps() =>
      (_db.select(_db.outbox)..orderBy([(t) => OrderingTerm.asc(t.id)])).get();

  Future<List<String>> idsMissingDetail() async {
    final rows = await (_db.select(_db.recipes)..where((t) => t.stepsJson.isNull())).get();
    return rows.map((row) => row.id).toList();
  }

  // ---- Server → device ----------------------------------------------------------------------

  Future<void> replaceTags(List<api.TagDimension> dimensions) => _db.transaction(() async {
        await _db.delete(_db.tags).go();
        await _db.batch((batch) {
          batch.insertAll(_db.tags, [
            for (final dimension in dimensions)
              for (final tag in dimension.tags)
                TagsCompanion.insert(
                  id: Value(tag.id),
                  dimensionId: dimension.id,
                  dimensionSlug: dimension.slug,
                  dimensionLabel: dimension.label,
                  slug: tag.slug,
                  label: tag.label,
                ),
          ]);
        });
      });

  /// Applies list summaries, keeping any synced detail and skipping recipes with pending edits.
  Future<void> applySummaries(List<api.RecipeListItemsInner> items, {required Set<String> skipIds}) =>
      _db.transaction(() async {
        for (final item in items.where((item) => !skipIds.contains(item.id))) {
          final summary = companionFromSummary(item);
          // `stepsJson` is absent from the companion, so an existing detail is preserved.
          await _db.into(_db.recipes).insert(summary, onConflict: DoUpdate((_) => summary));
          // Tag edits made elsewhere show up in the summary; ingredients only come with the detail.
          await _replaceTags(item.id, item.tags.map((t) => t.id).toList());
        }
      });

  Future<void> removeMissing(Set<String> remoteIds, {required Set<String> keepIds}) async {
    final rows = await _db.select(_db.recipes).get();
    final stale = rows.map((r) => r.id).where((id) => !remoteIds.contains(id) && !keepIds.contains(id));
    await (_db.delete(_db.recipes)..where((t) => t.id.isIn(stale.toList()))).go();
  }

  Future<void> upsertDetail(api.RecipeDetail detail) => _writeRows(rowsFromDetail(detail));

  /// A create was accepted: swap the local placeholder for the server's recipe.
  Future<void> replaceLocal(String localId, api.RecipeDetail detail, int outboxId) => _db.transaction(() async {
        await (_db.delete(_db.recipes)..where((t) => t.id.equals(localId))).go();
        await upsertDetail(detail);
        await removeOp(outboxId);
      });

  // ---- Device → server ----------------------------------------------------------------------

  /// Writes the recipe locally and queues the change. Returns the recipe id.
  Future<String> saveLocally(RecipeDraft draft, {String? id}) => _db.transaction(() async {
        final recipeId = id ?? _newLocalId();
        final existing =
            id == null ? null : await (_db.select(_db.recipes)..where((t) => t.id.equals(id))).getSingleOrNull();
        await _writeRows(rowsFromDraft(recipeId, draft, createdAt: existing?.createdAt ?? DateTime.now()));

        final payload = jsonEncode(inputFromDraft(draft).toJson());
        final queued = await _opsFor(recipeId);
        final pendingWrite = queued.where((op) => op.kind != 'delete').firstOrNull;
        if (pendingWrite != null) {
          // Fold repeated edits (and edits to a not-yet-created recipe) into the one queued write.
          await (_db.update(_db.outbox)..where((t) => t.id.equals(pendingWrite.id)))
              .write(OutboxCompanion(payloadJson: Value(payload)));
        } else {
          await _enqueue(id == null ? 'create' : 'update', recipeId, payload);
        }
        return recipeId;
      });

  Future<void> deleteLocally(String id) => _db.transaction(() async {
        final queued = await _opsFor(id);
        await (_db.delete(_db.outbox)..where((t) => t.recipeId.equals(id))).go();
        await (_db.delete(_db.recipes)..where((t) => t.id.equals(id))).go();
        // A recipe the server never saw needs no delete request.
        final neverSynced = isLocalId(id) || queued.any((op) => op.kind == 'create');
        if (!neverSynced) await _enqueue('delete', id, null);
      });

  Future<void> removeOp(int outboxId) => (_db.delete(_db.outbox)..where((t) => t.id.equals(outboxId))).go();

  // ---- Helpers ------------------------------------------------------------------------------

  Future<List<OutboxRow>> _opsFor(String recipeId) =>
      (_db.select(_db.outbox)..where((t) => t.recipeId.equals(recipeId))).get();

  Future<void> _enqueue(String kind, String recipeId, String? payload) => _db.into(_db.outbox).insert(
        OutboxCompanion.insert(kind: kind, recipeId: recipeId, payloadJson: Value(payload), createdAt: DateTime.now()),
      );

  Future<void> _writeRows(RecipeRows rows) => _db.transaction(() async {
        await _db.into(_db.recipes).insertOnConflictUpdate(rows.recipe);
        final id = rows.recipe.id.value;
        await (_db.delete(_db.recipeIngredients)..where((t) => t.recipeId.equals(id))).go();
        await _db.batch((batch) => batch.insertAll(_db.recipeIngredients, rows.ingredients));
        await _replaceTags(id, rows.tagIds);
      });

  Future<void> _replaceTags(String recipeId, List<int> tagIds) async {
    await (_db.delete(_db.recipeTags)..where((t) => t.recipeId.equals(recipeId))).go();
    await _db.batch((batch) {
      batch.insertAll(_db.recipeTags, [
        for (final tagId in tagIds.toSet()) RecipeTagsCompanion.insert(recipeId: recipeId, tagId: tagId),
      ]);
    });
  }

  String _newLocalId() => '$localIdPrefix${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 32)}';
}
