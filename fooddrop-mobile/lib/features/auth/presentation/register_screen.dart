import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/food_drop_colors.dart';
import '../../../core/widgets/labeled_text_field.dart';
import '../../../core/widgets/neon_button.dart';
import 'auth_form_controller.dart';
import 'auth_layout.dart';
import 'password_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() => ref
      .read(authFormProvider.notifier)
      .signUp(name: _name.text, email: _email.text, password: _password.text);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final form = ref.watch(authFormProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AuthHeroHeader(height: 170, backLabel: 'Quay lại đăng nhập'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Tạo tài khoản', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -0.6)),
                          const SizedBox(height: 6),
                          Text('Chỉ mất chưa đầy một phút.', style: TextStyle(fontSize: 14, color: colors.textMuted)),
                          const SizedBox(height: 18),
                          LabeledTextField(
                            label: 'Tên hiển thị',
                            controller: _name,
                            hint: 'Trang',
                            errorText: form.nameError,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.name],
                          ),
                          const SizedBox(height: 14),
                          LabeledTextField(
                            label: 'Email',
                            controller: _email,
                            hint: 'ban@vidu.com',
                            errorText: form.emailError,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                          ),
                          const SizedBox(height: 14),
                          PasswordField(
                            controller: _password,
                            label: 'Mật khẩu',
                            hint: 'Ít nhất 8 ký tự',
                            autofillHint: AutofillHints.newPassword,
                            errorText: form.passwordError,
                            onSubmitted: _submit,
                          ),
                          if (form.formError != null) AuthFormError(message: form.formError!),
                          const SizedBox(height: 18),
                          NeonButton(label: 'Tạo tài khoản', onPressed: _submit, loading: form.busy),
                          const Spacer(),
                          AuthSwitchRow(
                            question: 'Đã có tài khoản?',
                            action: 'Đăng nhập',
                            onTap: () => context.go('/login'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
