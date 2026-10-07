// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recipeLocalStore)
final recipeLocalStoreProvider = RecipeLocalStoreProvider._();

final class RecipeLocalStoreProvider
    extends
        $FunctionalProvider<
          RecipeLocalStore,
          RecipeLocalStore,
          RecipeLocalStore
        >
    with $Provider<RecipeLocalStore> {
  RecipeLocalStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeLocalStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeLocalStoreHash();

  @$internal
  @override
  $ProviderElement<RecipeLocalStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecipeLocalStore create(Ref ref) {
    return recipeLocalStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipeLocalStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipeLocalStore>(value),
    );
  }
}

String _$recipeLocalStoreHash() => r'3dc122636ee411fcd939f7e5b6c96541409c947f';

@ProviderFor(recipeRemote)
final recipeRemoteProvider = RecipeRemoteProvider._();

final class RecipeRemoteProvider
    extends $FunctionalProvider<RecipeRemote, RecipeRemote, RecipeRemote>
    with $Provider<RecipeRemote> {
  RecipeRemoteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeRemoteProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeRemoteHash();

  @$internal
  @override
  $ProviderElement<RecipeRemote> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecipeRemote create(Ref ref) {
    return recipeRemote(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipeRemote value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipeRemote>(value),
    );
  }
}

String _$recipeRemoteHash() => r'9615199e687f65a42c025634ca50c385473b7cbf';

@ProviderFor(recipeSyncService)
final recipeSyncServiceProvider = RecipeSyncServiceProvider._();

final class RecipeSyncServiceProvider
    extends
        $FunctionalProvider<
          RecipeSyncService,
          RecipeSyncService,
          RecipeSyncService
        >
    with $Provider<RecipeSyncService> {
  RecipeSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeSyncServiceHash();

  @$internal
  @override
  $ProviderElement<RecipeSyncService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecipeSyncService create(Ref ref) {
    return recipeSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipeSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipeSyncService>(value),
    );
  }
}

String _$recipeSyncServiceHash() => r'a38092ab60126d4c43a3207a068909e5e703a5db';

@ProviderFor(recipes)
final recipesProvider = RecipesProvider._();

final class RecipesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Recipe>>,
          List<Recipe>,
          Stream<List<Recipe>>
        >
    with $FutureModifier<List<Recipe>>, $StreamProvider<List<Recipe>> {
  RecipesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipesHash();

  @$internal
  @override
  $StreamProviderElement<List<Recipe>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Recipe>> create(Ref ref) {
    return recipes(ref);
  }
}

String _$recipesHash() => r'021c46795270d3c3e8881e75e434a7b88c8b3416';

@ProviderFor(recipe)
final recipeProvider = RecipeFamily._();

final class RecipeProvider
    extends $FunctionalProvider<AsyncValue<Recipe?>, Recipe?, Stream<Recipe?>>
    with $FutureModifier<Recipe?>, $StreamProvider<Recipe?> {
  RecipeProvider._({
    required RecipeFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'recipeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipeHash();

  @override
  String toString() {
    return r'recipeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Recipe?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Recipe?> create(Ref ref) {
    final argument = this.argument as String;
    return recipe(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipeHash() => r'39fee648f7d26b9bc58eae047e8ee6867b3b835b';

final class RecipeFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Recipe?>, String> {
  RecipeFamily._()
    : super(
        retry: null,
        name: r'recipeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RecipeProvider call(String id) => RecipeProvider._(argument: id, from: this);

  @override
  String toString() => r'recipeProvider';
}

@ProviderFor(tagGroups)
final tagGroupsProvider = TagGroupsProvider._();

final class TagGroupsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TagGroup>>,
          List<TagGroup>,
          Stream<List<TagGroup>>
        >
    with $FutureModifier<List<TagGroup>>, $StreamProvider<List<TagGroup>> {
  TagGroupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagGroupsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagGroupsHash();

  @$internal
  @override
  $StreamProviderElement<List<TagGroup>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TagGroup>> create(Ref ref) {
    return tagGroups(ref);
  }
}

String _$tagGroupsHash() => r'9b8f3056da006b23fd777087c939fb155f062c6a';

@ProviderFor(recipeActions)
final recipeActionsProvider = RecipeActionsProvider._();

final class RecipeActionsProvider
    extends $FunctionalProvider<RecipeActions, RecipeActions, RecipeActions>
    with $Provider<RecipeActions> {
  RecipeActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeActionsHash();

  @$internal
  @override
  $ProviderElement<RecipeActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecipeActions create(Ref ref) {
    return recipeActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipeActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipeActions>(value),
    );
  }
}

String _$recipeActionsHash() => r'd5bdf60f1ae3dcf5b2eafd56864e1f624ad2fef8';
