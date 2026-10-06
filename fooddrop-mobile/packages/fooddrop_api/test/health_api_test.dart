import 'package:test/test.dart';
import 'package:fooddrop_api/fooddrop_api.dart';


/// tests for HealthApi
void main() {
  final instance = FooddropApi().getHealthApi();

  group(HealthApi, () {
    //Future<HealthResponseDto> healthControllerGetHealth() async
    test('test healthControllerGetHealth', () async {
      // TODO
    });

  });
}
