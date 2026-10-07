import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_client_provider.dart';
import '../../recipes/domain/recipe_draft.dart';
import 'parser_remote.dart';
import 'photo_picker.dart';

part 'parser_providers.g.dart';

@Riverpod(keepAlive: true)
ParserRemote parserRemote(Ref ref) => ParserRemote(ref.watch(apiClientProvider));

@Riverpod(keepAlive: true)
PhotoPicker photoPicker(Ref ref) => const PhotoPicker();

/// How often a running job is polled; tests override it to avoid real waiting.
@Riverpod(keepAlive: true)
Duration importPollInterval(Ref ref) => const Duration(milliseconds: 1500);

/// Draft handed from the import screen to the "new recipe" form. The form clears it once shown,
/// so a later plain "new recipe" never starts from a stale import.
@Riverpod(keepAlive: true)
class ImportedDraft extends _$ImportedDraft {
  @override
  RecipeDraft? build() => null;

  void set(RecipeDraft draft) => state = draft;

  void clear() => state = null;
}
