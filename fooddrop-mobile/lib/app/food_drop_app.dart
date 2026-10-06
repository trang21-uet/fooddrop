import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.dart';

const brandBackground = Color(0xFF1A1A1F);

class FoodDropApp extends ConsumerWidget {
  const FoodDropApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Food Drop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: brandBackground,
      ),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
