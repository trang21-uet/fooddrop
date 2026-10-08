import 'dart:typed_data';

import 'package:fooddrop/features/parser/data/parser_remote.dart';
import 'package:fooddrop/features/parser/data/photo_picker.dart';
import 'package:fooddrop_api/fooddrop_api.dart' as api;

api.ParseJobResult parseResult({
  List<api.ParseJobResultIngredientsInner>? ingredients,
  List<api.ParseJobResultStepsInner>? steps,
  int? totalMinutes,
}) =>
    api.ParseJobResult(
      source_: api.ParseJobResultSource_Enum.jsonLd,
      title: 'Thịt kho trứng',
      description: null,
      imageUrl: null,
      sourceUrl: 'https://blog.example/thit-kho',
      baseServings: 4,
      totalMinutes: totalMinutes,
      difficulty: 3,
      ingredients: ingredients ??
          [
            api.ParseJobResultIngredientsInner(
              name: 'pork belly',
              quantity: 500,
              unit: 'g',
              note: null,
              matchedName: 'Thịt ba chỉ',
              ingredientId: 'ing-pork',
              isNew: false,
            ),
            api.ParseJobResultIngredientsInner(
              name: 'trứng cút',
              quantity: 12.5,
              unit: 'fruit',
              note: 'luộc chín',
              matchedName: null,
              ingredientId: null,
              isNew: true,
            ),
          ],
      steps: steps ?? [api.ParseJobResultStepsInner(text: 'Ướp thịt.'), api.ParseJobResultStepsInner(text: 'Hầm.', timerSeconds: 2700)],
      suggestedTagIds: [3, 7],
    );

api.ParseJob parseJob({
  api.ParseJobStatusEnum status = api.ParseJobStatusEnum.succeeded,
  api.ParseJobErrorCodeEnum? errorCode,
  api.ParseJobResult? result,
  int cooldownSeconds = 60,
}) =>
    api.ParseJob(
      id: 'job-1',
      status: status,
      sourceType: api.ParseJobSourceTypeEnum.url,
      errorCode: errorCode,
      result: result,
      createdAt: DateTime.utc(2026, 10, 7),
      cooldownSeconds: cooldownSeconds,
    );

/// Scripted server: answers a start with [created] (queued, [cooldownSeconds] wait), returns [jobs] one per
/// poll (the last repeats), or throws [startError].
class FakeParserRemote implements ParserRemote {
  FakeParserRemote({this.jobs = const [], this.startError, int cooldownSeconds = 60})
      : created = parseJob(status: api.ParseJobStatusEnum.queued, cooldownSeconds: cooldownSeconds);

  final api.ParseJob created;
  final List<api.ParseJob> jobs;
  final Object? startError;
  final started = <String>[];
  int _polls = 0;

  @override
  Future<api.ParseJob> startUrl(String url) async {
    if (startError != null) throw startError!;
    started.add('url:$url');
    return created;
  }

  @override
  Future<api.ParseJob> startImage(Uint8List bytes, api.CreateUploadContentTypeEnum contentType) async {
    if (startError != null) throw startError!;
    started.add('image:${bytes.length}:${contentType.value}');
    return created;
  }

  @override
  Future<api.ParseJob> getJob(String id) async => jobs[_polls < jobs.length ? _polls++ : jobs.length - 1];
}

class FakePhotoPicker implements PhotoPicker {
  FakePhotoPicker(this.photo, {this.many = const []});

  final PickedPhoto? photo;

  /// What [pickMany] returns (capped at the requested limit).
  final List<PickedPhoto> many;

  @override
  Future<PickedPhoto?> pick(PhotoSource source) async => photo;

  @override
  Future<List<PickedPhoto>> pickMany(PhotoSource source, {required int limit}) async => many.take(limit).toList();
}
