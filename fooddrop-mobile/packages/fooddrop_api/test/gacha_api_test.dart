import 'package:test/test.dart';
import 'package:fooddrop_api/fooddrop_api.dart';


/// tests for GachaApi
void main() {
  final instance = FooddropApi().getGachaApi();

  group(GachaApi, () {
    //Future<GachaCases> gachaControllerCases() async
    test('test gachaControllerCases', () async {
      // TODO
    });

    //Future<GachaSpinHistory> gachaControllerHistory({ int limit }) async
    test('test gachaControllerHistory', () async {
      // TODO
    });

    //Future<GachaSpin> gachaControllerSpin(CreateGachaSpin createGachaSpin) async
    test('test gachaControllerSpin', () async {
      // TODO
    });

  });
}
