import 'package:drift/drift.dart';

import 'legacy_outbox_payload.dart';

part 'app_database.g.dart';

/// Local copy of the user's recipes. Summaries arrive from the list endpoint; `stepsJson` is null
/// until the detail has been fetched (or the recipe was created on this device).
@DataClassName('RecipeRow')
class Recipes extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get sourceUrl => text().nullable()();
  IntColumn get baseServings => integer()();
  IntColumn get totalMinutes => integer()();
  IntColumn get difficulty => integer()();
  TextColumn get rarity => text()();
  TextColumn get stepsJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RecipeIngredientRow')
class RecipeIngredients extends Table {
  TextColumn get recipeId => text().references(Recipes, #id, onDelete: KeyAction.cascade)();
  TextColumn get ingredientId => text()();
  TextColumn get name => text()();
  TextColumn get aisle => text()();

  /// As the cook wrote it; both are optional. `unit` is a catalog code, with its names and kind
  /// copied alongside so a recipe renders offline without joining the units cache.
  RealColumn get quantity => real().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get unitNameVi => text().nullable()();
  TextColumn get unitNameEn => text().nullable()();
  TextColumn get unitKind => text().nullable()();
  TextColumn get note => text().nullable()();
  IntColumn get sortOrder => integer()();

  /// The server's g | ml | piece conversion, which the grocery list sums. Zero for a recipe edited
  /// offline until it syncs: the app never converts units itself.
  RealColumn get baseQuantity => real().withDefault(const Constant(0))();
  TextColumn get baseUnit => text().withDefault(const Constant('piece'))();

  /// Raw text ("1 1/2") for a quantity edited offline until the server has seen it.
  TextColumn get displayQuantity => text().nullable()();

  @override
  Set<Column> get primaryKey => {recipeId, ingredientId};
}

@DataClassName('RecipeTagRow')
class RecipeTags extends Table {
  TextColumn get recipeId => text().references(Recipes, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId => integer()();

  @override
  Set<Column> get primaryKey => {recipeId, tagId};
}

/// Cache of `GET /tags` (dimension columns are denormalized; the set is tiny).
@DataClassName('TagRow')
class Tags extends Table {
  IntColumn get id => integer()();
  IntColumn get dimensionId => integer()();
  TextColumn get dimensionSlug => text()();
  TextColumn get dimensionLabel => text()();
  TextColumn get slug => text()();
  TextColumn get label => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cache of `GET /units`: the units a recipe line can use, in picker order.
@DataClassName('UnitRow')
class Units extends Table {
  TextColumn get code => text()();
  TextColumn get nameVi => text()();
  TextColumn get nameEn => text()();
  TextColumn get kind => text()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {code};
}

/// Pending mutations, replayed in order when the network is available.
/// `kind` is `create` | `update` | `delete`; `payloadJson` is the RecipeInput for create/update.
@DataClassName('OutboxRow')
class Outbox extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => text()();
  TextColumn get recipeId => text()();
  TextColumn get payloadJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

/// Recipes on the grocery list. Deliberately no foreign key: a recipe's id changes from `local-…` to
/// the server id after its first sync, and the aggregated list is derived, never stored.
@DataClassName('GrocerySelectionRow')
class GrocerySelections extends Table {
  TextColumn get recipeId => text()();
  IntColumn get servings => integer()();

  @override
  Set<Column> get primaryKey => {recipeId};
}

/// Ticked-off grocery lines, keyed `ingredientId|unit`.
@DataClassName('GroceryCheckRow')
class GroceryChecks extends Table {
  TextColumn get itemKey => text()();

  @override
  Set<Column> get primaryKey => {itemKey};
}

/// Cooking timers. `id` doubles as the OS notification id. `endsAtMs` is an absolute epoch time;
/// `pausedRemainingMs` is set only while paused. `alertedAtMs` is set once the done-alert has fired.
@DataClassName('TimerRow')
class TimerEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
  IntColumn get endsAtMs => integer()();
  IntColumn get pausedRemainingMs => integer().nullable()();
  IntColumn get alertedAtMs => integer().nullable()();
}

// An unconvertible unit used to be stored as quantity 0 plus a note; those lines now show the note alone.
const _legacyZeroLine = 'quantity = 0 AND note IS NOT NULL';

// g / ml keep their code (and double as their own name); a bare count (piece) and legacy lines have no unit.
const _keptUnit = "CASE WHEN unit IN ('g', 'ml') AND NOT ($_legacyZeroLine) THEN unit END";

@DriftDatabase(
  tables: [Recipes, RecipeIngredients, RecipeTags, Tags, Units, Outbox, GrocerySelections, GroceryChecks, TimerEntries],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(grocerySelections);
            await m.createTable(groceryChecks);
            await m.createTable(timerEntries);
          }
          if (from < 3) {
            await m.createTable(units);
            // Lines were stored normalized to g | ml | piece. Those values are now the grocery base,
            // and the display unit is g / ml as written; a bare count (piece) becomes "no unit".
            await m.alterTable(
              TableMigration(
                recipeIngredients,
                columnTransformer: {
                  recipeIngredients.quantity: const CustomExpression('CASE WHEN $_legacyZeroLine THEN NULL ELSE quantity END'),
                  recipeIngredients.baseQuantity: recipeIngredients.quantity,
                  recipeIngredients.baseUnit: recipeIngredients.unit,
                  recipeIngredients.unit: const CustomExpression(_keptUnit),
                  recipeIngredients.unitNameVi: const CustomExpression(_keptUnit),
                  recipeIngredients.unitNameEn: const CustomExpression(_keptUnit),
                  recipeIngredients.unitKind: const CustomExpression(
                    "CASE WHEN $_legacyZeroLine THEN NULL ELSE CASE unit WHEN 'g' THEN 'mass' WHEN 'ml' THEN 'volume' END END",
                  ),
                },
                newColumns: [
                  recipeIngredients.unitNameVi,
                  recipeIngredients.unitNameEn,
                  recipeIngredients.unitKind,
                  recipeIngredients.baseQuantity,
                  recipeIngredients.baseUnit,
                ],
              ),
            );
            // Edits queued offline by the old app may carry free-text units the server now rejects.
            for (final op in await select(outbox).get()) {
              final payload = op.payloadJson;
              if (payload == null) continue;
              await (update(outbox)..where((t) => t.id.equals(op.id)))
                  .write(OutboxCompanion(payloadJson: Value(upgradeLegacyOutboxPayload(payload))));
            }
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Removes all user data (sign-out).
  Future<void> wipe() => transaction(() async {
        for (final table in allTables) {
          await delete(table).go();
        }
      });
}
