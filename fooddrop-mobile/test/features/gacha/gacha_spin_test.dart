import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/features/gacha/domain/gacha_spin.dart';
import 'package:fooddrop/features/recipes/domain/rarity.dart';

GachaCard _card(int i) => GachaCard(
      id: 'r$i',
      title: 'Món $i',
      imageUrl: i % 10 == 9 ? null : 'https://cdn.test/$i.jpg',
      rarity: Rarity.white,
      totalMinutes: 10,
      difficulty: 1,
      baseServings: 2,
    );

void main() {
  test('slow cards are the opening screen and the cards around the winner', () {
    final spin = GachaSpin(
      spinId: 's',
      result: _card(60),
      reel: List.generate(70, _card),
      winningIndex: 60,
      offsetJitter: 0,
      poolSize: 70,
    );
    final urls = spin.slowCardImageUrls;
    expect(urls, containsAll(['https://cdn.test/0.jpg', 'https://cdn.test/5.jpg', 'https://cdn.test/56.jpg', 'https://cdn.test/64.jpg']));
    expect(urls, isNot(contains('https://cdn.test/6.jpg')));
    expect(urls, isNot(contains('https://cdn.test/65.jpg')));
    expect(urls, hasLength(6 + 9 - 1)); // card 59 has no photo
  });
}
