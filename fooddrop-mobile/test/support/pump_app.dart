import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/app/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Pumps [routes] with the real theme. A tall phone-width surface keeps lazy lists fully built.
Future<ProviderContainer> pumpRoutes(
  WidgetTester tester, {
  required List<RouteBase> routes,
  List<Override> overrides = const [],
  String initialLocation = '/',
}) async {
  // Fonts come from the network in production; tests must not reach out for them.
  GoogleFonts.config.allowRuntimeFetching = false;
  tester.view.physicalSize = const Size(390, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final container = ProviderContainer(overrides: overrides);
  addTearDown(container.dispose);
  final router = GoRouter(initialLocation: initialLocation, routes: routes);
  addTearDown(router.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(theme: buildAppTheme(), routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

/// Home page with a button that pushes [path]; lets screens call `context.pop()`.
GoRoute homeThatOpens(String path) => GoRoute(
      path: '/',
      builder: (context, state) => Scaffold(
        body: Center(
          child: TextButton(onPressed: () => context.push(path), child: const Text('mở')),
        ),
      ),
    );
