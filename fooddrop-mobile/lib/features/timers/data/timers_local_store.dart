import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../domain/timer_entry.dart';
import '../domain/timer_math.dart';

/// Drift reads and writes for timers. The timers survive an app restart; so do their OS notifications.
class TimersLocalStore {
  TimersLocalStore(this._db);

  final AppDatabase _db;

  /// Soonest-ending first.
  SimpleSelectStatement<$TimerEntriesTable, TimerRow> get _ordered =>
      _db.select(_db.timerEntries)..orderBy([(t) => OrderingTerm.asc(t.endsAtMs)]);

  Stream<List<TimerEntry>> watchAll() => _ordered.watch().map((rows) => rows.map(_fromRow).toList());

  Future<List<TimerEntry>> getAll() async => (await _ordered.get()).map(_fromRow).toList();

  Future<TimerEntry?> byId(int id) async {
    final row = await (_db.select(_db.timerEntries)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  Future<TimerEntry> insert(String label, int endsAtMs) async {
    final id = await _db.into(_db.timerEntries).insert(TimerEntriesCompanion.insert(label: label, endsAtMs: endsAtMs));
    return TimerEntry(id: id, label: label, clock: TimerClock(endsAtMs: endsAtMs));
  }

  Future<void> save(TimerEntry timer) => (_db.update(_db.timerEntries)..where((t) => t.id.equals(timer.id))).write(
        TimerEntriesCompanion(
          endsAtMs: Value(timer.clock.endsAtMs),
          pausedRemainingMs: Value(timer.clock.pausedRemainingMs),
          alertedAtMs: Value(timer.alertedAtMs),
        ),
      );

  Future<void> delete(int id) => (_db.delete(_db.timerEntries)..where((t) => t.id.equals(id))).go();

  TimerEntry _fromRow(TimerRow row) => TimerEntry(
        id: row.id,
        label: row.label,
        clock: TimerClock(endsAtMs: row.endsAtMs, pausedRemainingMs: row.pausedRemainingMs),
        alertedAtMs: row.alertedAtMs,
      );
}
