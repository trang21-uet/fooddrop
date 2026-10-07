import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/food_drop_colors.dart';

/// Bold label above a rounded filled input (52px), with an inline error line below.
class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.obscureText = false,
    this.suffix,
    this.maxLines = 1,
    this.inputFormatters,
    this.fieldKey,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final Widget? suffix;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    OutlineInputBorder border(Color color) =>
        OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: color));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          key: fieldKey,
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          obscureText: obscureText,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: colors.textMuted),
            filled: true,
            fillColor: colors.surface,
            suffixIcon: suffix,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: maxLines > 1 ? 14 : 0),
            constraints: maxLines > 1 ? null : const BoxConstraints(minHeight: 52),
            enabledBorder: border(errorText == null ? colors.border : colors.danger),
            focusedBorder: border(errorText == null ? colors.accent : colors.danger),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(errorText!, style: TextStyle(fontSize: 13, color: colors.danger)),
          ),
      ],
    );
  }
}
