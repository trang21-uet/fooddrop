import 'package:test/test.dart';
import 'package:fooddrop_api/fooddrop_api.dart';


/// tests for UnitsApi
void main() {
  final instance = FooddropApi().getUnitsApi();

  group(UnitsApi, () {
    //Future<List<Unit>> unitsControllerList() async
    test('test unitsControllerList', () async {
      // TODO
    });

  });
}
