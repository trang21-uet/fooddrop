import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/recipes/data/sync_controller.dart';
import 'app_router.dart';
import 'app_theme.dart';

class FoodDropApp extends ConsumerStatefulWidget {
  const FoodDropApp({super.key});

  @override
  ConsumerState<FoodDropApp> createState() => _FoodDropAppState();
}

class _FoodDropAppState extends ConsumerState<FoodDropApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Coming back to the app is the moment queued offline edits get another chance to sync.
    _lifecycle = AppLifecycleListener(
      onResume: () => ref.read(syncControllerProvider.notifier).sync(),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Food Drop',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      themeMode: ThemeMode.dark,
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
