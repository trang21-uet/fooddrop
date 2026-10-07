// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_catalog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ingredientCatalog)
final ingredientCatalogProvider = IngredientCatalogProvider._();

final class IngredientCatalogProvider
    extends
        $FunctionalProvider<
          IngredientCatalog,
          IngredientCatalog,
          IngredientCatalog
        >
    with $Provider<IngredientCatalog> {
  IngredientCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ingredientCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ingredientCatalogHash();

  @$internal
  @override
  $ProviderElement<IngredientCatalog> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IngredientCatalog create(Ref ref) {
    return ingredientCatalog(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IngredientCatalog value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IngredientCatalog>(value),
    );
  }
}

String _$ingredientCatalogHash() => r'95bdd17c2e287fc8edae45cea02ac71820f84151';

@ProviderFor(ingredientSearch)
final ingredientSearchProvider = IngredientSearchFamily._();

final class IngredientSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<IngredientOption>>,
          List<IngredientOption>,
          FutureOr<List<IngredientOption>>
        >
    with
        $FutureModifier<List<IngredientOption>>,
        $FutureProvider<List<IngredientOption>> {
  IngredientSearchProvider._({
    required IngredientSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'ingredientSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ingredientSearchHash();

  @override
  String toString() {
    return r'ingredientSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<IngredientOption>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<IngredientOption>> create(Ref ref) {
    final argument = this.argument as String;
    return ingredientSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IngredientSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ingredientSearchHash() => r'eb4ec3855492bf5283d097dd7e66ce813399f186';

final class IngredientSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<IngredientOption>>, String> {
  IngredientSearchFamily._()
    : super(
        retry: null,
        name: r'ingredientSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IngredientSearchProvider call(String query) =>
      IngredientSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'ingredientSearchProvider';
}
