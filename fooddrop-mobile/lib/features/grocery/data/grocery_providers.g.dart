// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grocery_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(groceryLocalStore)
final groceryLocalStoreProvider = GroceryLocalStoreProvider._();

final class GroceryLocalStoreProvider
    extends
        $FunctionalProvider<
          GroceryLocalStore,
          GroceryLocalStore,
          GroceryLocalStore
        >
    with $Provider<GroceryLocalStore> {
  GroceryLocalStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groceryLocalStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groceryLocalStoreHash();

  @$internal
  @override
  $ProviderElement<GroceryLocalStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GroceryLocalStore create(Ref ref) {
    return groceryLocalStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GroceryLocalStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GroceryLocalStore>(value),
    );
  }
}

String _$groceryLocalStoreHash() => r'a41e46c70f0053c7f8b3d2cf8aa5483c6da46f43';

@ProviderFor(grocerySelections)
final grocerySelectionsProvider = GrocerySelectionsProvider._();

final class GrocerySelectionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GrocerySelection>>,
          List<GrocerySelection>,
          Stream<List<GrocerySelection>>
        >
    with
        $FutureModifier<List<GrocerySelection>>,
        $StreamProvider<List<GrocerySelection>> {
  GrocerySelectionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'grocerySelectionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$grocerySelectionsHash();

  @$internal
  @override
  $StreamProviderElement<List<GrocerySelection>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<GrocerySelection>> create(Ref ref) {
    return grocerySelections(ref);
  }
}

String _$grocerySelectionsHash() => r'2b49a7453f99f1f8b4883c824b33c1007fc49777';

@ProviderFor(groceryChecked)
final groceryCheckedProvider = GroceryCheckedProvider._();

final class GroceryCheckedProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          Stream<Set<String>>
        >
    with $FutureModifier<Set<String>>, $StreamProvider<Set<String>> {
  GroceryCheckedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groceryCheckedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groceryCheckedHash();

  @$internal
  @override
  $StreamProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Set<String>> create(Ref ref) {
    return groceryChecked(ref);
  }
}

String _$groceryCheckedHash() => r'3267f45dc34f8019033029e1bce414e461837710';

/// The aggregated, aisle-grouped list. Derived from selections + recipes on every change, never stored.

@ProviderFor(groceryList)
final groceryListProvider = GroceryListProvider._();

/// The aggregated, aisle-grouped list. Derived from selections + recipes on every change, never stored.

final class GroceryListProvider
    extends
        $FunctionalProvider<
          List<GroceryAisleGroup>,
          List<GroceryAisleGroup>,
          List<GroceryAisleGroup>
        >
    with $Provider<List<GroceryAisleGroup>> {
  /// The aggregated, aisle-grouped list. Derived from selections + recipes on every change, never stored.
  GroceryListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groceryListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groceryListHash();

  @$internal
  @override
  $ProviderElement<List<GroceryAisleGroup>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<GroceryAisleGroup> create(Ref ref) {
    return groceryList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<GroceryAisleGroup> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<GroceryAisleGroup>>(value),
    );
  }
}

String _$groceryListHash() => r'89f7b7de830db8cfb83c4a11ff31d4d73331b55a';

/// Opens the system share sheet; tests override it.

@ProviderFor(shareText)
final shareTextProvider = ShareTextProvider._();

/// Opens the system share sheet; tests override it.

final class ShareTextProvider
    extends $FunctionalProvider<ShareText, ShareText, ShareText>
    with $Provider<ShareText> {
  /// Opens the system share sheet; tests override it.
  ShareTextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shareTextProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shareTextHash();

  @$internal
  @override
  $ProviderElement<ShareText> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShareText create(Ref ref) {
    return shareText(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShareText value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShareText>(value),
    );
  }
}

String _$shareTextHash() => r'28e81ab56b90eda2be52d4fa65dd75ae14b7d833';

@ProviderFor(groceryActions)
final groceryActionsProvider = GroceryActionsProvider._();

final class GroceryActionsProvider
    extends $FunctionalProvider<GroceryActions, GroceryActions, GroceryActions>
    with $Provider<GroceryActions> {
  GroceryActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groceryActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groceryActionsHash();

  @$internal
  @override
  $ProviderElement<GroceryActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GroceryActions create(Ref ref) {
    return groceryActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GroceryActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GroceryActions>(value),
    );
  }
}

String _$groceryActionsHash() => r'065f752dede5da1229144d38411a0d97a2f9a19f';
