import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/food_drop_colors.dart';
import '../data/gacha_providers.dart';
import '../domain/gacha_spin.dart';
import '../domain/reel_geometry.dart';
import 'reel_card.dart';
import 'reel_stage_decor.dart';

/// The CSS `cubic-bezier(0.1, 0.7, 0.1, 1)` the web reel uses: fast start, long crawl at the end.
const reelCurve = Cubic(0.1, 0.7, 0.1, 1);
const _reducedMotionFade = Duration(seconds: 1);

/// Before the first spin the marker sits on this card, so cards fill both sides.
const _idleIndex = 3;

/// Vertical room above and below the cards, as on the design board.
const _stagePadding = 40.0;
const _placeholderCards = <GachaCard?>[null, null, null, null, null, null, null, null];

/// Horizontal strip of cards that animates to `spin.winningIndex`. The offset lives in the
/// AnimationController and a ValueNotifier, never in Riverpod, so a spin rebuilds no cards.
class CaseReel extends ConsumerStatefulWidget {
  const CaseReel({
    super.key,
    required this.spin,
    this.idleCards = const [],
    required this.spinning,
    required this.onLanded,
  });

  final GachaSpin? spin;

  /// Shown before the first spin; mystery cards when empty.
  final List<GachaCard> idleCards;
  final bool spinning;
  final VoidCallback onLanded;

  @override
  ConsumerState<CaseReel> createState() => _CaseReelState();
}

class _CaseReelState extends ConsumerState<CaseReel> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this)
    ..addListener(_onFrame)
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onLanded();
    });
  final _offset = ValueNotifier<double>(0);
  final _opacity = ValueNotifier<double>(1);
  ReelLayout? _layout;
  double _end = 0;
  int _slot = 0;
  bool _reducedMotion = false;

  @override
  void initState() {
    super.initState();
    if (widget.spinning) WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  @override
  void didUpdateWidget(CaseReel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spinning && (!oldWidget.spinning || widget.spin != oldWidget.spin)) {
      // After this frame, so the new strip is laid out before it moves.
      WidgetsBinding.instance.addPostFrameCallback((_) => _start());
    }
  }

  void _start() {
    final spin = widget.spin;
    final layout = _layout;
    if (!mounted || spin == null || layout == null) return;
    _end = layout.targetOffset(spin.winningIndex, spin.offsetJitter);
    _slot = layout.slotUnderMarker(0);
    _reducedMotion = MediaQuery.disableAnimationsOf(context);
    _offset.value = _reducedMotion ? _end : 0;
    _controller
      ..duration = _reducedMotion ? _reducedMotionFade : ref.read(spinDurationProvider)
      ..forward(from: 0);
  }

  void _onFrame() {
    final t = _controller.value;
    if (_reducedMotion) {
      _opacity.value = t;
      return;
    }
    final offset = reelCurve.transform(t) * _end;
    _offset.value = offset;
    final slot = _layout!.slotUnderMarker(offset);
    if (slot != _slot) {
      _slot = slot;
      ref.read(reelSoundPlayerProvider).tick();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _offset.dispose();
    _opacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spin = widget.spin;
    final cards = spin?.reel ?? (widget.idleCards.isEmpty ? _placeholderCards : widget.idleCards);
    final strip = RepaintBoundary(
      child: OverflowBox(
        alignment: Alignment.centerLeft,
        minWidth: 0,
        maxWidth: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(width: reelCardGap),
              ReelCard(card: cards[i]),
            ],
          ],
        ),
      ),
    );

    return ExcludeSemantics(
      // Decorative: the result is announced by the reveal dialog.
      child: RepaintBoundary(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final layout = ReelLayout(cardWidth: reelCardWidth, gap: reelCardGap, viewportWidth: constraints.maxWidth);
            _layout = layout;
            // At rest the marker is on the winner where the spin stopped, otherwise on an idle card.
            final resting = spin == null
                ? layout.targetOffset(_idleIndex, 0)
                : layout.targetOffset(spin.winningIndex, spin.offsetJitter);
            return Container(
              height: reelCardHeight + 2 * _stagePadding,
              decoration: BoxDecoration(
                color: _stageColor,
                border: Border.symmetric(horizontal: BorderSide(color: colors.border)),
              ),
              child: ClipRect(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: Listenable.merge([_offset, _opacity, _controller]),
                        builder: (context, child) => Opacity(
                          opacity: _opacity.value,
                          child: Transform.translate(
                            offset: Offset(-(_controller.isAnimating ? _offset.value : resting), 0),
                            child: child,
                          ),
                        ),
                        child: Align(alignment: Alignment.centerLeft, child: strip),
                      ),
                    ),
                    const Positioned.fill(child: ReelStageDecor(background: _stageColor)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

const _stageColor = Color(0xFF17110F);
