// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_filters_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RecipeFiltersController)
final recipeFiltersControllerProvider = RecipeFiltersControllerProvider._();

final class RecipeFiltersControllerProvider
    extends $NotifierProvider<RecipeFiltersController, RecipeFilters> {
  RecipeFiltersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeFiltersControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeFiltersControllerHash();

  @$internal
  @override
  RecipeFiltersController create() => RecipeFiltersController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipeFilters value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipeFilters>(value),
    );
  }
}

String _$recipeFiltersControllerHash() =>
    r'5d0ffa72932242ae626700801e858ff5c25c833a';

abstract class _$RecipeFiltersController extends $Notifier<RecipeFilters> {
  RecipeFilters build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RecipeFilters, RecipeFilters>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RecipeFilters, RecipeFilters>,
              RecipeFilters,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Recipes after on-device filtering. Empty while the first load is in flight.

@ProviderFor(filteredRecipes)
final filteredRecipesProvider = FilteredRecipesProvider._();

/// Recipes after on-device filtering. Empty while the first load is in flight.

final class FilteredRecipesProvider
    extends $FunctionalProvider<List<Recipe>, List<Recipe>, List<Recipe>>
    with $Provider<List<Recipe>> {
  /// Recipes after on-device filtering. Empty while the first load is in flight.
  FilteredRecipesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredRecipesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredRecipesHash();

  @$internal
  @override
  $ProviderElement<List<Recipe>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Recipe> create(Ref ref) {
    return filteredRecipes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Recipe> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Recipe>>(value),
    );
  }
}

String _$filteredRecipesHash() => r'c6d6e3bb0911d6efe576f9d10429e50bd78d9900';
