import 'package:flutter/material.dart';

import '../../../app/food_drop_colors.dart';
import '../../recipes/presentation/shared/photo_url_view.dart';
import '../domain/gacha_spin.dart';

const reelCardWidth = 150.0;
const reelCardGap = 10.0;
const reelCardHeight = 220.0;

/// Decode width of reel photos; `ReelImagePreloader` uses the same so precaching hits the card's cache entry.
const reelCardCacheWidth = 360;

/// One slot of the reel: the photo on top, the name below; the border colour is the rarity. A null [card]
/// is the mystery card shown while the case loads.
class ReelCard extends StatelessWidget {
  const ReelCard({super.key, required this.card});

  final GachaCard? card;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final card = this.card;
    if (card == null) {
      return Container(
        width: reelCardWidth,
        height: reelCardHeight,
        decoration: BoxDecoration(
          color: colors.surfaceRaised,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
        ),
        child: Icon(Icons.inventory_2_outlined, size: 40, color: colors.textMuted),
      );
    }

    final rarity = colors.rarity(card.rarity);
    const cardBackground = Color(0xFF241C19);
    final icon = DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.1),
          colors: [Color.lerp(cardBackground, rarity, 0.25)!, cardBackground],
          stops: const [0, 0.75],
        ),
      ),
      child: Center(child: Icon(Icons.ramen_dining_outlined, size: 56, color: colors.text.withValues(alpha: 0.7))),
    );
    return Container(
      width: reelCardWidth,
      height: reelCardHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: rarity, width: 2),
        boxShadow: [BoxShadow(color: rarity.withValues(alpha: 0.6), blurRadius: 18, spreadRadius: 1)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: card.imageUrl == null
                ? icon
                : PhotoUrlView(url: card.imageUrl!, placeholder: icon, cacheWidth: reelCardCacheWidth),
          ),
          DecoratedBox(
            decoration: BoxDecoration(color: colors.surface, border: Border(top: BorderSide(color: colors.border))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
              child: Text(
                card.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
