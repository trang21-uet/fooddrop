import 'package:test/test.dart';
import 'package:fooddrop_api/fooddrop_api.dart';


/// tests for MediaApi
void main() {
  final instance = FooddropApi().getMediaApi();

  group(MediaApi, () {
    //Future<UploadTarget> mediaControllerCreateUpload(CreateUpload createUpload) async
    test('test mediaControllerCreateUpload', () async {
      // TODO
    });

  });
}
