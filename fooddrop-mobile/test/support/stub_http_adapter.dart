import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fooddrop_api/fooddrop_api.dart';

/// Answers requests from a route table, so auth flows run without a server.
class StubHttpAdapter implements HttpClientAdapter {
  StubHttpAdapter(this.routes);

  /// `"POST /api/auth/sign-in/email"` → (status, JSON body, headers).
  final Map<String, ({int status, Object body, Map<String, String> headers})> routes;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    final route = routes['${options.method} ${options.path}'];
    if (route == null) {
      return ResponseBody.fromString('{"message":"no stub"}', 404, headers: {'content-type': ['application/json']});
    }
    return ResponseBody.fromString(
      jsonEncode(route.body),
      route.status,
      headers: {
        'content-type': ['application/json'],
        for (final entry in route.headers.entries) entry.key: [entry.value],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// API client whose Dio talks to [adapter] instead of the network.
FooddropApi stubApi(StubHttpAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'http://stub'))..httpClientAdapter = adapter;
  return FooddropApi(dio: dio);
}

