import 'package:fooddrop_api/fooddrop_api.dart' as api;

import '../../recipes/domain/rarity.dart';
import '../domain/gacha_case.dart';
import '../domain/gacha_spin.dart';

/// Thin wrapper over the generated client. Spins need a connection: the server draws the result.
class GachaRemote {
  GachaRemote(this._api);

  final api.FooddropApi _api;

  /// Every case with its count, rarity mix and rarest dishes; cases this app does not know yet are skipped.
  Future<List<GachaCaseSummary>> cases() async {
    final response = await _api.getGachaApi().gachaControllerCases();
    return [
      for (final item in response.data!.items)
        if (GachaCaseId.fromApi(item.id.value) case final id?)
          GachaCaseSummary(
            id: id,
            recipeCount: item.recipeCount,
            rarityCounts: {
              Rarity.white: item.rarityCounts.white,
              Rarity.blue: item.rarityCounts.blue,
              Rarity.purple: item.rarityCounts.purple,
              Rarity.pink: item.rarityCounts.pink,
              Rarity.red: item.rarityCounts.red,
            },
            preview: item.preview.map(_card).toList(growable: false),
          ),
    ];
  }

  Future<GachaSpin> spin(GachaCaseId caseId) async {
    final response = await _api.getGachaApi().gachaControllerSpin(
          createGachaSpin: api.CreateGachaSpin(
            caseType: api.CreateGachaSpinCaseTypeEnum.cook,
            caseId: api.CreateGachaSpinCaseIdEnum.values.byName(caseId.apiValue),
          ),
        );
    final spin = response.data!;
    return GachaSpin(
      spinId: spin.spinId,
      result: _card(spin.result),
      reel: spin.reel.map(_card).toList(growable: false),
      winningIndex: spin.winningIndex,
      offsetJitter: spin.offsetJitter.toDouble(),
      poolSize: spin.poolSize,
    );
  }

  Future<List<SpinHistoryEntry>> history({int limit = 10}) async {
    final response = await _api.getGachaApi().gachaControllerHistory(limit: limit);
    return response.data!.items
        .map((item) {
          final result = item.result;
          return SpinHistoryEntry(
            id: item.id,
            createdAt: item.createdAt,
            result: result == null
                ? null
                : GachaCard(
                    id: result.id,
                    title: result.title,
                    imageUrl: result.imageUrl,
                    rarity: Rarity.fromApi(result.rarity.value),
                    totalMinutes: result.totalMinutes,
                    difficulty: result.difficulty,
                    baseServings: result.baseServings,
                  ),
          );
        })
        .toList(growable: false);
  }

  static GachaCard _card(api.GachaSpinResult card) => GachaCard(
        id: card.id,
        title: card.title,
        imageUrl: card.imageUrl,
        rarity: Rarity.fromApi(card.rarity.value),
        totalMinutes: card.totalMinutes,
        difficulty: card.difficulty,
        baseServings: card.baseServings,
      );
}
