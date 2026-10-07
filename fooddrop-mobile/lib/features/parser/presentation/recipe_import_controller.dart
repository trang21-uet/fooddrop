import 'dart:async';
import 'dart:typed_data';

import 'package:fooddrop_api/fooddrop_api.dart' as api;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_error.dart';
import '../data/parse_job_mapper.dart';
import '../data/parser_providers.dart';
import '../data/photo_picker.dart';
import '../domain/parse_error_message.dart';

part 'recipe_import_controller.g.dart';

enum ImportPhase { idle, working, failed, done }

class ImportState {
  const ImportState({this.phase = ImportPhase.idle, this.message});

  final ImportPhase phase;

  /// Vietnamese explanation when [phase] is [ImportPhase.failed].
  final String? message;
}

const _jobTimeout = Duration(seconds: 90);

/// Runs one import: start the job, poll until it finishes, then hand the draft to the recipe form.
@riverpod
class RecipeImportController extends _$RecipeImportController {
  @override
  ImportState build() => const ImportState();

  Future<void> importUrl(String url) => _run(() => ref.read(parserRemoteProvider).startUrl(url.trim()));

  Future<void> importPhoto(PhotoSource source) async {
    final PickedPhoto? photo;
    try {
      photo = await ref.read(photoPickerProvider).pick(source);
    } catch (_) {
      state = const ImportState(phase: ImportPhase.failed, message: 'Không mở được máy ảnh hoặc thư viện ảnh.');
      return;
    }
    if (photo == null) return;
    if (photo.bytes.length > maxPhotoBytes) {
      state = const ImportState(phase: ImportPhase.failed, message: 'Ảnh quá lớn (tối đa 5 MB). Hãy chọn ảnh khác.');
      return;
    }
    await _run(() => ref.read(parserRemoteProvider).startImage(Uint8List.fromList(photo!.bytes), photo.contentType));
  }

  void reset() => state = const ImportState();

  Future<void> _run(Future<String> Function() start) async {
    state = const ImportState(phase: ImportPhase.working);
    final String jobId;
    try {
      jobId = await start();
    } catch (error) {
      if (ref.mounted) state = ImportState(phase: ImportPhase.failed, message: describeImportStartError(error));
      return;
    }

    try {
      final job = await _waitFor(jobId);
      if (!ref.mounted) return;
      final result = job.result;
      if (job.status == api.ParseJobStatusEnum.succeeded && result != null) {
        ref.read(importedDraftProvider.notifier).set(draftFromParseResult(result));
        state = const ImportState(phase: ImportPhase.done);
      } else {
        state = ImportState(phase: ImportPhase.failed, message: describeParseFailure(job.errorCode));
      }
    } on TimeoutException {
      if (ref.mounted) {
        state = const ImportState(
          phase: ImportPhase.failed,
          message: 'Việc đọc công thức mất quá lâu. Vui lòng thử lại.',
        );
      }
    } catch (error) {
      if (ref.mounted) state = ImportState(phase: ImportPhase.failed, message: describeApiError(error));
    }
  }

  Future<api.ParseJob> _waitFor(String jobId) async {
    final remote = ref.read(parserRemoteProvider);
    final interval = ref.read(importPollIntervalProvider);
    final deadline = DateTime.now().add(_jobTimeout);
    while (ref.mounted) {
      final job = await remote.getJob(jobId);
      if (job.status == api.ParseJobStatusEnum.succeeded || job.status == api.ParseJobStatusEnum.failed) return job;
      if (!DateTime.now().isBefore(deadline)) throw TimeoutException('parse job $jobId');
      await Future<void>.delayed(interval);
    }
    throw TimeoutException('import cancelled');
  }
}
