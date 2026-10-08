import 'package:drift/drift.dart';
import 'package:fooddrop_api/fooddrop_api.dart' as api;

import '../../../core/db/app_database.dart';
import '../domain/recipe_unit.dart';

/// Drift cache of `GET /units`, so the unit dropdown works offline.
class UnitLocalStore {
  UnitLocalStore(this._db);

  final AppDatabase _db;

  /// In picker order; empty until the first sync.
  Stream<List<RecipeUnit>> watch() => _ordered().watch().map(_toUnits);

  Future<List<RecipeUnit>> load() async => _toUnits(await _ordered().get());

  Future<void> replace(List<api.Unit> units) => _db.transaction(() async {
        await _db.delete(_db.units).go();
        await _db.batch((batch) {
          batch.insertAll(_db.units, [
            for (final (index, unit) in units.indexed)
              UnitsCompanion.insert(
                code: unit.code,
                nameVi: unit.nameVi,
                nameEn: unit.nameEn,
                kind: unit.kind.value,
                sortOrder: index,
              ),
          ]);
        });
      });

  SimpleSelectStatement<$UnitsTable, UnitRow> _ordered() =>
      _db.select(_db.units)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);

  List<RecipeUnit> _toUnits(List<UnitRow> rows) => [
        for (final row in rows) RecipeUnit(code: row.code, nameVi: row.nameVi, nameEn: row.nameEn, kind: row.kind),
      ];
}
