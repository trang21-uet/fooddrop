import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fooddrop/core/media/media_uploader.dart';
import 'package:fooddrop/features/recipes/data/recipe_providers.dart';
import 'package:fooddrop/features/recipes/domain/recipe_draft.dart';
import 'package:fooddrop_api/fooddrop_api.dart' as api;

import 'fake_recipe_remote.dart';

typedef SavedDraft = ({RecipeDraft draft, String? id});

class RecordingRecipeActions extends RecipeActions {
  RecordingRecipeActions(super.ref, this.saved);

  final List<SavedDraft> saved;

  @override
  Future<String> save(RecipeDraft draft, {String? id}) async {
    saved.add((draft: draft, id: id));
    return id ?? 'local-new';
  }
}

/// Storage stand-in: hands out numbered keys, or fails like a dropped connection.
class FakeMediaUploader implements MediaUploader {
  FakeMediaUploader({this.fail = false, this.failStatus});

  final bool fail;
  final int? failStatus;
  final purposes = <api.CreateUploadPurposeEnum>[];

  @override
  Future<String> upload(
    Uint8List bytes,
    api.CreateUploadContentTypeEnum contentType,
    api.CreateUploadPurposeEnum purpose,
  ) async {
    if (failStatus != null) throw dioError(DioExceptionType.badResponse, status: failStatus);
    if (fail) throw dioError(DioExceptionType.connectionError);
    purposes.add(purpose);
    return 'recipes/u1/${purposes.length}.jpg';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
