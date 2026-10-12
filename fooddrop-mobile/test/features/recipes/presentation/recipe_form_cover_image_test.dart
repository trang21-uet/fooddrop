import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:fooddrop/core/media/media_providers.dart';
import 'package:fooddrop/features/parser/data/parser_providers.dart';
import 'package:fooddrop/features/parser/data/photo_picker.dart';
import 'package:fooddrop/features/recipes/data/recipe_providers.dart';
import 'package:fooddrop/features/recipes/presentation/form/recipe_form_screen.dart';
import 'package:fooddrop_api/fooddrop_api.dart' as api;
import 'package:go_router/go_router.dart';

import '../../../support/parser_fixtures.dart';
import '../../../support/pump_app.dart';
import '../../../support/recipe_form_fakes.dart';

PickedPhoto _photo() => PickedPhoto(Uint8List(8), api.CreateUploadContentTypeEnum.imageSlashJpeg, path: '/cache/cover.jpg');

void main() {
  late List<SavedDraft> saved;

  setUp(() => saved = []);

  Future<void> openForm(WidgetTester tester, List<Override> overrides) async {
    await pumpRoutes(
      tester,
      overrides: [
        recipeActionsProvider.overrideWith((ref) => RecordingRecipeActions(ref, saved)),
        tagGroupsProvider.overrideWith((ref) => Stream.value(const [])),
        unitsProvider.overrideWith((ref) => Stream.value(const [])),
        ...overrides,
      ],
      routes: [
        homeThatOpens('/form'),
        GoRoute(path: '/form', builder: (context, state) => const RecipeFormScreen(recipeId: null)),
      ],
    );
    await tester.tap(find.text('mở'));
    await tester.pumpAndSettle();
  }

  Future<void> pickCover(WidgetTester tester) async {
    await tester.tap(find.text('Thêm ảnh món'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chọn từ thư viện'));
    await tester.pumpAndSettle();
  }

  Future<void> save(WidgetTester tester) async {
    await tester.enterText(find.byKey(const ValueKey('recipe-title')), 'Bún chả');
    final stepText = find.byWidgetPredicate(
      (widget) => widget is TextFormField && widget.key is ValueKey && '${(widget.key! as ValueKey).value}'.startsWith('step-text-'),
    );
    await tester.enterText(stepText, 'Nướng thịt');
    await tester.tap(find.text('Lưu công thức'));
    await tester.pumpAndSettle();
  }

  testWidgets('a cover photo is uploaded from the device and saved as its storage key', (tester) async {
    final uploader = FakeMediaUploader();
    await openForm(tester, [
      photoPickerProvider.overrideWithValue(FakePhotoPicker(_photo())),
      mediaUploaderProvider.overrideWithValue(uploader),
    ]);

    await pickCover(tester);

    expect(uploader.purposes, [api.CreateUploadPurposeEnum.recipeCover]);
    expect(find.text('Đổi ảnh khác'), findsOneWidget);
    await save(tester);
    final draft = saved.single.draft;
    expect((draft.imageKey, draft.imageUrl), ('recipes/u1/1.jpg', 'file:///cache/cover.jpg'));
  });

  testWidgets('a cover photo can be removed again', (tester) async {
    await openForm(tester, [
      photoPickerProvider.overrideWithValue(FakePhotoPicker(_photo())),
      mediaUploaderProvider.overrideWithValue(FakeMediaUploader()),
    ]);
    await pickCover(tester);

    await tester.tap(find.byTooltip('Xóa ảnh món'));
    await tester.pumpAndSettle();

    expect(find.text('Thêm ảnh món'), findsOneWidget);
    await save(tester);
    expect((saved.single.draft.imageKey, saved.single.draft.imageUrl), (null, null));
  });

  testWidgets('without a connection the cover is not set and the user is told why', (tester) async {
    await openForm(tester, [
      photoPickerProvider.overrideWithValue(FakePhotoPicker(_photo())),
      mediaUploaderProvider.overrideWithValue(FakeMediaUploader(fail: true)),
    ]);

    await pickCover(tester);

    expect(find.byKey(const Key('cover-image-error')), findsOneWidget);
    expect(find.text('Thêm ảnh món'), findsOneWidget);
  });
}
