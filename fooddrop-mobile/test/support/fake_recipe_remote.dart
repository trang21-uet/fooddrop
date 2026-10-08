import 'package:dio/dio.dart';
import 'package:fooddrop/features/recipes/data/recipe_remote.dart';
import 'package:fooddrop_api/fooddrop_api.dart' as api;

import 'recipe_fixtures.dart';

DioException dioError(DioExceptionType type, {int? status}) {
  final options = RequestOptions(path: '/recipes');
  return DioException(
    requestOptions: options,
    type: type,
    response: status == null ? null : Response(requestOptions: options, statusCode: status),
  );
}

/// Server stand-in: holds recipes in memory and can be told to fail.
class FakeRemote implements RecipeRemote {
  final server = <String, api.RecipeDetail>{};
  final calls = <String>[];
  Object? failWith;
  Object? failUpdateWith;
  int _created = 0;

  void _maybeFail() {
    if (failWith != null) throw failWith!;
  }

  @override
  Future<List<api.RecipeListItemsInner>> listAll() async {
    calls.add('list');
    _maybeFail();
    return [for (final d in server.values) apiSummary(id: d.id, title: d.title)];
  }

  @override
  Future<api.RecipeDetail> get(String id) async {
    calls.add('get:$id');
    _maybeFail();
    return server[id]!;
  }

  @override
  Future<api.RecipeDetail> create(api.RecipeInput input) async {
    calls.add('create:${input.title}');
    _maybeFail();
    final detail = apiDetail(id: 'server-${++_created}', title: input.title);
    server[detail.id] = detail;
    return detail;
  }

  @override
  Future<api.RecipeDetail> update(String id, api.RecipeInput input) async {
    calls.add('update:$id');
    if (failUpdateWith != null) throw failUpdateWith!;
    _maybeFail();
    return server[id] = apiDetail(id: id, title: input.title);
  }

  @override
  Future<void> delete(String id) async {
    calls.add('delete:$id');
    _maybeFail();
    server.remove(id);
  }

  @override
  Future<List<api.TagDimension>> tags() async {
    calls.add('tags');
    _maybeFail();
    return [apiTagDimension()];
  }

  @override
  Future<List<api.Unit>> units() async {
    calls.add('units');
    _maybeFail();
    return apiUnits();
  }

  @override
  Future<List<api.Ingredient>> searchIngredients(String query) => throw UnimplementedError();

  @override
  Future<api.Ingredient> createIngredient(String name, {String defaultUnit = 'g'}) => throw UnimplementedError();
}
