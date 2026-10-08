import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/core/media/media_providers.dart';
import 'package:fooddrop/core/media/media_uploader.dart';
import 'package:fooddrop/features/parser/data/parser_providers.dart';
import 'package:fooddrop/features/parser/data/photo_picker.dart';
import 'package:fooddrop/features/recipes/data/recipe_providers.dart';
import 'package:fooddrop/features/recipes/domain/rarity.dart';
import 'package:fooddrop/features/recipes/domain/recipe.dart';
import 'package:fooddrop/features/recipes/domain/recipe_draft.dart';
import 'package:fooddrop/features/recipes/presentation/form/recipe_form_screen.dart';
import 'package:fooddrop_api/fooddrop_api.dart' as api;
import 'package:go_router/go_router.dart';

import '../../../support/fake_recipe_remote.dart';
import '../../../support/parser_fixtures.dart';
import '../../../support/pump_app.dart';
import '../../../support/recipe_fixtures.dart';

typedef _Saved = ({RecipeDraft draft, String? id});

class _RecordingActions extends RecipeActions {
  _RecordingActions(super.ref, this.saved);

  final List<_Saved> saved;

  @override
  Future<String> save(RecipeDraft draft, {String? id}) async {
    saved.add((draft: draft, id: id));
    return id ?? 'local-new';
  }
}

/// Storage stand-in: hands out numbered keys, or fails like a dropped connection.
class _FakeUploader implements MediaUploader {
  _FakeUploader({this.fail = false, this.failStatus});

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

PickedPhoto _photo() => PickedPhoto(Uint8List(8), api.CreateUploadContentTypeEnum.imageSlashJpeg);

final _stepText = find.byWidgetPredicate((widget) {
  final key = widget.key;
  return widget is TextFormField && key is ValueKey && key.value.toString().startsWith('step-text-');
});
final _stepName = find.byWidgetPredicate((widget) {
  final key = widget.key;
  return widget is TextFormField && key is ValueKey && key.value.toString().startsWith('step-name-');
});

void main() {
  late List<_Saved> saved;

  setUp(() => saved = []);

  Future<void> openForm(WidgetTester tester, {List<Override> overrides = const [], String? recipeId}) async {
    await pumpRoutes(
      tester,
      overrides: [
        recipeActionsProvider.overrideWith((ref) => _RecordingActions(ref, saved)),
        tagGroupsProvider.overrideWith((ref) => Stream.value(const [])),
        unitsProvider.overrideWith((ref) => Stream.value(const [gramUnit, tbspUnit, fruitUnit])),
        ...overrides,
      ],
      routes: [
        homeThatOpens('/form'),
        GoRoute(path: '/form', builder: (context, state) => RecipeFormScreen(recipeId: recipeId)),
      ],
    );
    await tester.tap(find.text('mở'));
    await tester.pumpAndSettle();
  }

  Future<void> pickFromLibrary(WidgetTester tester) async {
    await tester.ensureVisible(find.byIcon(Icons.add_photo_alternate_outlined));
    await tester.tap(find.byIcon(Icons.add_photo_alternate_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chọn từ thư viện (nhiều ảnh)'));
    await tester.pumpAndSettle();
  }

  testWidgets('a step has its own name and content fields and both are saved', (tester) async {
    await openForm(tester);

    await tester.enterText(find.byKey(const ValueKey('recipe-title')), 'Bún chả');
    await tester.enterText(_stepName, 'Sơ chế');
    await tester.enterText(_stepText, 'Rửa sạch rau');
    await tester.tap(find.text('Lưu công thức'));
    await tester.pumpAndSettle();

    final step = saved.single.draft.steps.single;
    expect((step.name, step.text), ('Sơ chế', 'Rửa sạch rau'));
  });

  testWidgets('several photos can be added to a step, removed again, and are saved as storage keys', (tester) async {
    final uploader = _FakeUploader();
    await openForm(
      tester,
      overrides: [
        photoPickerProvider.overrideWithValue(FakePhotoPicker(null, many: [_photo(), _photo()])),
        mediaUploaderProvider.overrideWithValue(uploader),
      ],
    );

    await pickFromLibrary(tester);

    expect(uploader.purposes, [api.CreateUploadPurposeEnum.recipeStep, api.CreateUploadPurposeEnum.recipeStep]);
    expect(find.byTooltip('Xóa ảnh 1 của bước 1'), findsOneWidget);
    expect(find.byTooltip('Xóa ảnh 2 của bước 1'), findsOneWidget);

    await tester.tap(find.byTooltip('Xóa ảnh 1 của bước 1'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Xóa ảnh 2 của bước 1'), findsNothing);

    await tester.enterText(find.byKey(const ValueKey('recipe-title')), 'Bún chả');
    await tester.enterText(_stepText, 'Nướng thịt');
    await tester.tap(find.text('Lưu công thức'));
    await tester.pumpAndSettle();

    expect(saved.single.draft.steps.single.images.map((image) => image.key), ['recipes/u1/2.jpg']);
  });

  testWidgets('without a connection the photo is not added and the user is told why', (tester) async {
    await openForm(
      tester,
      overrides: [
        photoPickerProvider.overrideWithValue(FakePhotoPicker(null, many: [_photo()])),
        mediaUploaderProvider.overrideWithValue(_FakeUploader(fail: true)),
      ],
    );

    await pickFromLibrary(tester);

    expect(find.text('Cần kết nối mạng để thêm ảnh.'), findsOneWidget);
    expect(find.byTooltip('Xóa ảnh 1 của bước 1'), findsNothing);
  });

  testWidgets('a server without object storage (503) is not reported as being offline', (tester) async {
    await openForm(
      tester,
      overrides: [
        photoPickerProvider.overrideWithValue(FakePhotoPicker(null, many: [_photo()])),
        mediaUploaderProvider.overrideWithValue(_FakeUploader(failStatus: 503)),
      ],
    );

    await pickFromLibrary(tester);

    expect(find.text('Máy chủ chưa bật tính năng tải ảnh.'), findsOneWidget);
  });

  testWidgets('an oversized photo is refused before uploading', (tester) async {
    final uploader = _FakeUploader();
    final big = PickedPhoto(Uint8List(maxPhotoBytes + 1), api.CreateUploadContentTypeEnum.imageSlashJpeg);
    await openForm(
      tester,
      overrides: [
        photoPickerProvider.overrideWithValue(FakePhotoPicker(null, many: [big])),
        mediaUploaderProvider.overrideWithValue(uploader),
      ],
    );

    await pickFromLibrary(tester);

    expect(find.textContaining('tối đa 5 MB'), findsOneWidget);
    expect(uploader.purposes, isEmpty);
  });

  group('ingredient quantity and unit', () {
    Recipe recipeWith(List<RecipeIngredient> ingredients) => Recipe(
          id: 'r1',
          title: 'Canh',
          baseServings: 2,
          totalMinutes: 20,
          difficulty: 1,
          rarity: Rarity.white,
          createdAt: DateTime.utc(2026),
          ingredients: ingredients,
          steps: const [RecipeStep(text: 'Nấu')],
        );

    testWidgets('both are optional: an ingredient with neither saves fine', (tester) async {
      final recipe = recipeWith(const [RecipeIngredient(ingredientId: 'salt', name: 'Muối', aisle: 'spices', note: 'tùy khẩu vị')]);
      await openForm(tester, recipeId: 'r1', overrides: [recipeProvider('r1').overrideWith((ref) => Stream.value(recipe))]);

      await tester.tap(find.text('Lưu công thức'));
      await tester.pumpAndSettle();

      final row = saved.single.draft.ingredients.single;
      expect((row.quantityText, row.unitCode), ('', ''));
    });

    testWidgets('the unit is picked from the catalog by its Vietnamese name', (tester) async {
      final recipe = recipeWith(const [
        RecipeIngredient(ingredientId: 'sauce', name: 'Nước mắm', aisle: 'pantry', quantity: 2, unit: tbspUnit),
      ]);
      await openForm(tester, recipeId: 'r1', overrides: [recipeProvider('r1').overrideWith((ref) => Stream.value(recipe))]);

      expect(find.text('thìa canh'), findsOneWidget, reason: 'the saved unit is preselected');

      await tester.tap(find.text('thìa canh'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('quả').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lưu công thức'));
      await tester.pumpAndSettle();

      final row = saved.single.draft.ingredients.single;
      expect((row.quantityText, row.unitCode), ('2', 'fruit'));
    });
  });
}
