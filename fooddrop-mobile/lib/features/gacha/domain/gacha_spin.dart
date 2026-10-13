import '../../recipes/domain/rarity.dart';

/// One reel card: what the strip shows, plus `baseServings` for "Add to grocery".
class GachaCard {
  const GachaCard({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.rarity,
    required this.totalMinutes,
    required this.difficulty,
    required this.baseServings,
  });

  final String id;
  final String title;
  final String? imageUrl;
  final Rarity rarity;
  final int totalMinutes;
  final int difficulty;
  final int baseServings;
}

/// A server-decided spin. `reel[winningIndex]` is the result; the client only animates to it.
class GachaSpin {
  const GachaSpin({
    required this.spinId,
    required this.result,
    required this.reel,
    required this.winningIndex,
    required this.offsetJitter,
    required this.poolSize,
  });

  final String spinId;
  final GachaCard result;
  final List<GachaCard> reel;
  final int winningIndex;

  /// Where the marker stops inside the winning card, in card widths from its center (−0.4..0.4).
  final double offsetJitter;

  /// Recipes that matched the filters; a small pool means a repetitive reel.
  final int poolSize;

  /// Photos of the cards seen at slow speed: the opening screen and around the winner.
  /// The reel waits for these (briefly) so it never starts or stops on blank cards.
  List<String> get slowCardImageUrls {
    const startCards = 6;
    const landingRadius = 4;
    final landing = reel.sublist(
      (winningIndex - landingRadius).clamp(0, reel.length),
      (winningIndex + landingRadius + 1).clamp(0, reel.length),
    );
    return {
      for (final card in [...reel.take(startCards), ...landing])
        if (card.imageUrl != null) card.imageUrl!,
    }.toList();
  }
}

class SpinHistoryEntry {
  const SpinHistoryEntry({required this.id, required this.createdAt, required this.result});

  final String id;
  final DateTime createdAt;

  /// Null once the recipe was deleted.
  final GachaCard? result;
}
