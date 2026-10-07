import 'package:flutter/material.dart';

import '../../../app/food_drop_colors.dart';
import '../../../core/widgets/labeled_text_field.dart';

/// Password input with a show/hide toggle (44px hit target).
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.autofillHint,
    this.errorText,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String autofillHint;
  final String? errorText;
  final VoidCallback? onSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  final _obscured = ValueNotifier(true);

  @override
  void dispose() {
    _obscured.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ValueListenableBuilder(
      valueListenable: _obscured,
      builder: (context, obscured, _) => LabeledTextField(
        label: widget.label,
        controller: widget.controller,
        hint: widget.hint,
        errorText: widget.errorText,
        obscureText: obscured,
        autofillHints: [widget.autofillHint],
        textInputAction: TextInputAction.done,
        onSubmitted: widget.onSubmitted == null ? null : (_) => widget.onSubmitted!(),
        suffix: IconButton(
          tooltip: obscured ? 'Hiện mật khẩu' : 'Ẩn mật khẩu',
          constraints: const BoxConstraints.tightFor(width: 44, height: 44),
          onPressed: () => _obscured.value = !obscured,
          icon: Icon(
            obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: colors.textMuted,
            size: 20,
          ),
        ),
      ),
    );
  }
}
