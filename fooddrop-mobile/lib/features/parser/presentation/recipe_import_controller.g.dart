// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_import_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Runs one import: start the job, poll until it finishes, then hand the draft to the recipe form.

@ProviderFor(RecipeImportController)
final recipeImportControllerProvider = RecipeImportControllerProvider._();

/// Runs one import: start the job, poll until it finishes, then hand the draft to the recipe form.
final class RecipeImportControllerProvider
    extends $NotifierProvider<RecipeImportController, ImportState> {
  /// Runs one import: start the job, poll until it finishes, then hand the draft to the recipe form.
  RecipeImportControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeImportControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeImportControllerHash();

  @$internal
  @override
  RecipeImportController create() => RecipeImportController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImportState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImportState>(value),
    );
  }
}

String _$recipeImportControllerHash() =>
    r'a1551a4733c6947fda0a4878f678855facef2c31';

/// Runs one import: start the job, poll until it finishes, then hand the draft to the recipe form.

abstract class _$RecipeImportController extends $Notifier<ImportState> {
  ImportState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ImportState, ImportState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ImportState, ImportState>,
              ImportState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
