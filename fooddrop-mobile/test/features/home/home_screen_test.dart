import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/app/food_drop_app.dart';

void main() {
  testWidgets('app boots into the Food Drop home screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FoodDropApp()));
    await tester.pumpAndSettle();

    expect(find.text('Food Drop'), findsOneWidget);
  });
}
