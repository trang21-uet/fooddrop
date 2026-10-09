import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/food_drop_colors.dart';
import '../../../../core/widgets/labeled_text_field.dart';
import '../../domain/recipe_draft.dart';
import 'recipe_form_controller.dart';
import 'recipe_form_step_images.dart';
import 'step_timer_toggle.dart';

const _defaultTimerMinutes = 10;

/// One step: numbered badge beside name, instructions, an optional note, photos and an optional timer.
class RecipeFormStepCard extends ConsumerStatefulWidget {
  const RecipeFormStepCard({
    super.key,
    required this.index,
    required this.step,
    required this.isFirst,
    required this.isLast,
    required this.error,
    required this.recipeId,
  });

  final int index;
  final DraftStep step;
  final bool isFirst;
  final bool isLast;
  final String? error;
  final String? recipeId;

  @override
  ConsumerState<RecipeFormStepCard> createState() => _RecipeFormStepCardState();
}

class _RecipeFormStepCardState extends ConsumerState<RecipeFormStepCard> {
  // Local, so clearing the minutes while typing does not hide the field.
  late bool _timerOn = widget.step.timerMinutes != null;

  void _toggleTimer() {
    final controller = ref.read(recipeFormControllerProvider(widget.recipeId).notifier);
    controller.updateStepTimer(widget.step.uid, _timerOn ? '' : '$_defaultTimerMinutes');
    setState(() => _timerOn = !_timerOn);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final controller = ref.read(recipeFormControllerProvider(widget.recipeId).notifier);
    final step = widget.step;
    final n = widget.index + 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.error == null ? colors.border : colors.danger),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: colors.accent)),
            child: Text('$n', style: monoStyle()),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledTextField(
                  fieldKey: ValueKey('step-name-${step.uid}'),
                  label: 'Tên bước (tùy chọn)',
                  initialValue: step.name,
                  hint: 'Ví dụ: Ướp thịt',
                  inputFormatters: [LengthLimitingTextInputFormatter(100)],
                  onChanged: (value) => controller.updateStepName(step.uid, value),
                ),
                const SizedBox(height: 12),
                LabeledTextField(
                  fieldKey: ValueKey('step-text-${step.uid}'),
                  label: 'Nội dung',
                  initialValue: step.text,
                  hint: 'Mô tả bước này',
                  maxLines: 3,
                  errorText: widget.error,
                  onChanged: (value) => controller.updateStepText(step.uid, value),
                ),
                const SizedBox(height: 12),
                LabeledTextField(
                  fieldKey: ValueKey('step-note-${step.uid}'),
                  label: 'Lưu ý (tùy chọn)',
                  initialValue: step.note,
                  hint: 'Mẹo hoặc điều cần tránh ở bước này',
                  maxLines: 2,
                  inputFormatters: [LengthLimitingTextInputFormatter(500)],
                  onChanged: (value) => controller.updateStepNote(step.uid, value),
                ),
                const SizedBox(height: 12),
                StepImagesEditor(step: step, index: widget.index, recipeId: widget.recipeId),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    StepTimerToggle(on: _timerOn, onTap: _toggleTimer),
                    if (_timerOn)
                      SizedBox(
                        width: 104,
                        child: TextFormField(
                          key: ValueKey('step-timer-${step.uid}'),
                          initialValue: step.timerMinutes?.toString(),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                          style: monoStyle(size: 15),
                          decoration: InputDecoration(
                            suffixText: 'phút',
                            isDense: true,
                            constraints: const BoxConstraints(minHeight: 44),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            enabledBorder: _border(colors.border),
                            focusedBorder: _border(colors.accent),
                          ),
                          onChanged: (value) => controller.updateStepTimer(step.uid, value),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _IconAction(
                      tooltip: 'Chuyển bước $n lên',
                      icon: Icons.keyboard_arrow_up_rounded,
                      onPressed: widget.isFirst ? null : () => controller.moveStep(step.uid, -1),
                    ),
                    _IconAction(
                      tooltip: 'Chuyển bước $n xuống',
                      icon: Icons.keyboard_arrow_down_rounded,
                      onPressed: widget.isLast ? null : () => controller.moveStep(step.uid, 1),
                    ),
                    _IconAction(
                      tooltip: 'Xóa bước $n',
                      icon: Icons.delete_outline_rounded,
                      color: colors.danger,
                      onPressed: () => controller.removeStep(step.uid),
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

  OutlineInputBorder _border(Color color) =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: color));
}

class _IconAction extends StatelessWidget {
  const _IconAction({required this.tooltip, required this.icon, required this.onPressed, this.color});

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: tooltip,
        constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        onPressed: onPressed,
        icon: Icon(icon, size: 22, color: onPressed == null ? context.colors.border : color ?? context.colors.textMuted),
      );
}
