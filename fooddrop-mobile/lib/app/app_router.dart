import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/auth/auth_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/recipes/presentation/detail/recipe_detail_screen.dart';
import '../features/recipes/presentation/form/recipe_form_screen.dart';
import '../features/recipes/presentation/list/recipe_list_screen.dart';
import 'splash_screen.dart';

part 'app_router.g.dart';

const _authPaths = {'/login', '/register'};

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // Re-evaluate redirects whenever the session appears or disappears.
  final authChanges = ValueNotifier(0);
  ref.listen(authControllerProvider, (_, _) => authChanges.value++);
  ref.onDispose(authChanges.dispose);

  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: authChanges,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      if (auth.isLoading) return state.matchedLocation == '/' ? null : '/';
      final signedIn = auth.value != null;
      final path = state.matchedLocation;
      if (!signedIn) return _authPaths.contains(path) ? null : '/login';
      return _authPaths.contains(path) || path == '/' ? '/recipes' : null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(
        path: '/recipes',
        builder: (context, state) => const RecipeListScreen(),
        routes: [
          // Declared before ':id' so "new" is not read as a recipe id.
          GoRoute(path: 'new', builder: (context, state) => const RecipeFormScreen()),
          GoRoute(
            path: ':id',
            builder: (context, state) => RecipeDetailScreen(recipeId: state.pathParameters['id']!),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => RecipeFormScreen(recipeId: state.pathParameters['id']),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}
