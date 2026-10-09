import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/food_drop_colors.dart';
import '../../../../core/widgets/neon_button.dart';
import '../../../parser/data/parser_providers.dart';
import '../../data/recipe_providers.dart';
import 'recipe_form_basics.dart';
import 'recipe_form_controller.dart';
import 'recipe_form_ingredients.dart';
import 'recipe_form_steps.dart';

/// Create (`recipeId == null`) or edit a recipe. Saves to the device first; syncing happens behind it.
class RecipeFormScreen extends ConsumerWidget {
  const RecipeFormScreen({super.key, this.recipeId});

  final String? recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = recipeId == null ? 'Công thức mới' : 'Sửa công thức';
    final id = recipeId;
    // Editing waits for the stored recipe so the form starts from its values.
    if (id != null && !ref.watch(recipeProvider(id)).hasValue) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return _FormBody(recipeId: id, title: title);
  }
}

class _FormBody extends ConsumerStatefulWidget {
  const _FormBody({required this.recipeId, required this.title});

  final String? recipeId;
  final String title;

  @override
  ConsumerState<_FormBody> createState() => _FormBodyState();
}

class _FormBodyState extends ConsumerState<_FormBody> {
  String? get recipeId => widget.recipeId;
  String get title => widget.title;

  @override
  void initState() {
    super.initState();
    // The controller reads an imported draft while building (first frame); drop it afterwards so
    // the next plain "new recipe" starts empty.
    if (recipeId == null) Future.microtask(() => ref.read(importedDraftProvider.notifier).clear());
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final savedId = await ref.read(recipeFormControllerProvider(recipeId).notifier).submit();
    if (savedId == null || !context.mounted) return;
    // A new recipe has a device-only id until its first sync, so go back to the list.
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final provider = recipeFormControllerProvider(recipeId);
    final saving = ref.watch(provider.select((s) => s.saving));
    final saveError = ref.watch(provider.select((s) => s.saveError));
    final hasErrors = ref.watch(provider.select((s) => s.errors != null && !s.errors!.isEmpty));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            _CloseButton(onPressed: () => context.pop()),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.4))),
          ],
        ),
        shape: Border(bottom: BorderSide(color: colors.border)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                RecipeFormBasics(recipeId: recipeId),
                const _SectionTitle('Nguyên liệu'),
                RecipeFormIngredients(recipeId: recipeId),
                const _SectionTitle('Cách làm'),
                RecipeFormSteps(recipeId: recipeId),
                const _SectionTitle('Thẻ'),
                RecipeFormTags(recipeId: recipeId),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + MediaQuery.paddingOf(context).bottom),
            decoration: BoxDecoration(color: colors.surface, border: Border(top: BorderSide(color: colors.border))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasErrors || saveError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      saveError ?? 'Còn trường chưa hợp lệ, kiểm tra các ô báo đỏ.',
                      style: TextStyle(fontSize: 13, color: colors.danger),
                    ),
                  ),
                Row(
                  children: [
                    SizedBox(
                      width: 96,
                      child: NeonButton(
                        label: 'Hủy',
                        style: NeonButtonStyle.outline,
                        height: 52,
                        onPressed: saving ? null : () => context.pop(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: NeonButton(
                        label: 'Lưu công thức',
                        height: 52,
                        loading: saving,
                        onPressed: () => _save(context, ref),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 44px bordered close button from the design's header.
class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox.square(
      dimension: 44,
      child: IconButton(
        tooltip: 'Đóng',
        onPressed: onPressed,
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: colors.border)),
        ),
        icon: Icon(Icons.close_rounded, size: 20, color: colors.text),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 26, bottom: 10),
        child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      );
}
