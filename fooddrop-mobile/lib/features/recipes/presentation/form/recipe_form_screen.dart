import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/food_drop_colors.dart';
import '../../../../core/widgets/neon_button.dart';
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

class _FormBody extends ConsumerWidget {
  const _FormBody({required this.recipeId, required this.title});

  final String? recipeId;
  final String title;

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final savedId = await ref.read(recipeFormControllerProvider(recipeId).notifier).submit();
    if (savedId == null || !context.mounted) return;
    // A new recipe has a device-only id until its first sync, so go back to the list.
    context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final provider = recipeFormControllerProvider(recipeId);
    final saving = ref.watch(provider.select((s) => s.saving));
    final saveError = ref.watch(provider.select((s) => s.saveError));
    final hasErrors = ref.watch(provider.select((s) => s.errors != null && !s.errors!.isEmpty));

    return Scaffold(
      appBar: AppBar(title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700))),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                RecipeFormBasics(recipeId: recipeId),
                const _SectionTitle('Thẻ'),
                RecipeFormTags(recipeId: recipeId),
                const _SectionTitle('Nguyên liệu'),
                RecipeFormIngredients(recipeId: recipeId),
                const _SectionTitle('Cách làm'),
                RecipeFormSteps(recipeId: recipeId),
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
                NeonButton(
                  label: 'Lưu công thức',
                  height: 52,
                  loading: saving,
                  onPressed: () => _save(context, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 28, bottom: 12),
        child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      );
}
