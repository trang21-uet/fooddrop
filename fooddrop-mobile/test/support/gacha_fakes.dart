import 'package:fooddrop/features/gacha/data/gacha_remote.dart';
import 'package:fooddrop/features/gacha/data/tick_sound_player.dart';
import 'package:fooddrop/features/gacha/domain/gacha_case.dart';
import 'package:fooddrop/features/gacha/domain/gacha_spin.dart';
import 'package:fooddrop/features/recipes/domain/rarity.dart';

GachaCard gachaCard(String id, {Rarity rarity = Rarity.white, String? title}) => GachaCard(
      id: id,
      title: title ?? 'Món $id',
      imageUrl: null,
      rarity: rarity,
      totalMinutes: 15,
      difficulty: 1,
      baseServings: 2,
    );

final gachaWinner = gachaCard('win', rarity: Rarity.purple, title: 'Bún chả');

final gachaSpin = GachaSpin(
  spinId: 's1',
  result: gachaWinner,
  reel: [for (var i = 0; i < 70; i++) i == 60 ? gachaWinner : gachaCard('f$i')],
  winningIndex: 60,
  offsetJitter: 0.2,
  poolSize: 3,
);

/// A featured case (`all`, `quick`, `epic`) or, with [label], a tag case like `meal_type.dinner`.
GachaCaseSummary gachaCase(
  String id, {
  int count = 0,
  String? label,
  GachaCaseGroup group = GachaCaseGroup.featured,
  List<GachaCard> preview = const [],
}) =>
    GachaCaseSummary(
      id: id,
      group: group,
      label: label,
      recipeCount: count,
      rarityCounts: {Rarity.purple: count},
      preview: preview,
    );

/// The featured cases plus a "Bữa tối" tag case; only those in [counts] hold recipes.
List<GachaCaseSummary> fakeGachaCases(Map<String, int> counts) => [
      for (final id in ['all', 'quick', 'epic', 'meal_type.dinner'])
        gachaCase(
          id,
          count: counts[id] ?? 0,
          label: id == 'meal_type.dinner' ? 'Bữa tối' : null,
          group: id == 'meal_type.dinner' ? GachaCaseGroup.mealType : GachaCaseGroup.featured,
          preview: (counts[id] ?? 0) > 0 ? [gachaCard('p-$id', title: 'Phở bò')] : const [],
        ),
    ];

class FakeGachaRemote implements GachaRemote {
  Object? failure;
  List<GachaCaseSummary> caseList = fakeGachaCases({'all': 3, 'meal_type.dinner': 3});
  final spins = <String>[];

  @override
  Future<List<GachaCaseSummary>> cases() async => caseList;

  @override
  Future<GachaSpin> spin(String caseId) async {
    spins.add(caseId);
    if (failure != null) throw failure!;
    return gachaSpin;
  }

  @override
  Future<List<SpinHistoryEntry>> history({int limit = 10}) async =>
      [SpinHistoryEntry(id: 'h1', createdAt: DateTime(2026, 10, 13, 9, 5), result: null)];
}

class FakeReelSounds implements ReelSoundPlayer {
  int ticks = 0;
  final reveals = <Rarity>[];

  @override
  Future<void> init() async {}

  @override
  void tick() => ticks++;

  @override
  void reveal(Rarity rarity) => reveals.add(rarity);
}
