import 'package:test/test.dart';
import 'package:fooddrop_api/fooddrop_api.dart';


/// tests for ParserApi
void main() {
  final instance = FooddropApi().getParserApi();

  group(ParserApi, () {
    //Future<ParseJob> parserControllerCreate(CreateParseJob createParseJob) async
    test('test parserControllerCreate', () async {
      // TODO
    });

    //Future<ParseJob> parserControllerGet(String id) async
    test('test parserControllerGet', () async {
      // TODO
    });

  });
}
