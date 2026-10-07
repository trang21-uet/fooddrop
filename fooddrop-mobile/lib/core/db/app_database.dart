import 'package:drift/drift.dart';

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
  RealColumn get quantity => real()();
  TextColumn get unit => text()();
  TextColumn get note => text().nullable()();
  IntColumn get sortOrder => integer()();

  /// Raw text ("1 1/2 thìa") shown until the server normalizes a quantity that was edited offline.
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

@DriftDatabase(tables: [Recipes, RecipeIngredients, RecipeTags, Tags, Outbox])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
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
