import 'package:test/test.dart';
import 'package:fooddrop_api/fooddrop_api.dart';


/// tests for TagsApi
void main() {
  final instance = FooddropApi().getTagsApi();

  group(TagsApi, () {
    //Future<List<TagDimension>> tagsControllerList() async
    test('test tagsControllerList', () async {
      // TODO
    });

  });
}
