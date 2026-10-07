// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Form state for creating (`recipeId == null`) or editing a recipe. Edits go through the
/// controller so the screen holds no state beyond its text controllers.

@ProviderFor(RecipeFormController)
final recipeFormControllerProvider = RecipeFormControllerFamily._();

/// Form state for creating (`recipeId == null`) or editing a recipe. Edits go through the
/// controller so the screen holds no state beyond its text controllers.
final class RecipeFormControllerProvider
    extends $NotifierProvider<RecipeFormController, RecipeFormState> {
  /// Form state for creating (`recipeId == null`) or editing a recipe. Edits go through the
  /// controller so the screen holds no state beyond its text controllers.
  RecipeFormControllerProvider._({
    required RecipeFormControllerFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'recipeFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipeFormControllerHash();

  @override
  String toString() {
    return r'recipeFormControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RecipeFormController create() => RecipeFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipeFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipeFormState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeFormControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipeFormControllerHash() =>
    r'cfb6b5fc6b16df41fb427cc885dbbeac7b0823bc';

/// Form state for creating (`recipeId == null`) or editing a recipe. Edits go through the
/// controller so the screen holds no state beyond its text controllers.

final class RecipeFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          RecipeFormController,
          RecipeFormState,
          RecipeFormState,
          RecipeFormState,
          String?
        > {
  RecipeFormControllerFamily._()
    : super(
        retry: null,
        name: r'recipeFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Form state for creating (`recipeId == null`) or editing a recipe. Edits go through the
  /// controller so the screen holds no state beyond its text controllers.

  RecipeFormControllerProvider call(String? recipeId) =>
      RecipeFormControllerProvider._(argument: recipeId, from: this);

  @override
  String toString() => r'recipeFormControllerProvider';
}

/// Form state for creating (`recipeId == null`) or editing a recipe. Edits go through the
/// controller so the screen holds no state beyond its text controllers.

abstract class _$RecipeFormController extends $Notifier<RecipeFormState> {
  late final _$args = ref.$arg as String?;
  String? get recipeId => _$args;

  RecipeFormState build(String? recipeId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RecipeFormState, RecipeFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RecipeFormState, RecipeFormState>,
              RecipeFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
