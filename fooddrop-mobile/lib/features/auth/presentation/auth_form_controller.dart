import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/auth/auth_remote.dart';

part 'auth_form_controller.g.dart';

class AuthFormState {
  const AuthFormState({this.busy = false, this.nameError, this.emailError, this.passwordError, this.formError});

  final bool busy;
  final String? nameError;
  final String? emailError;
  final String? passwordError;

  /// Server-side failure (wrong password, email taken, offline) not tied to one field.
  final String? formError;
}

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Submit state for the login and register forms: field validation, busy flag and server errors.
/// Navigation happens by itself: the router redirects once the session exists.
@riverpod
class AuthForm extends _$AuthForm {
  @override
  AuthFormState build() => const AuthFormState();

  Future<void> signIn({required String email, required String password}) async {
    final emailError = _validateEmail(email);
    final passwordError = password.isEmpty ? 'Nhập mật khẩu' : null;
    if (emailError != null || passwordError != null) {
      state = AuthFormState(emailError: emailError, passwordError: passwordError);
      return;
    }
    await _submit(() => ref.read(authControllerProvider.notifier).signIn(email: email.trim(), password: password));
  }

  Future<void> signUp({required String name, required String email, required String password}) async {
    final nameError = name.trim().isEmpty ? 'Nhập tên hiển thị' : null;
    final emailError = _validateEmail(email);
    final passwordError = password.length < 8 ? 'Mật khẩu cần ít nhất 8 ký tự.' : null;
    if (nameError != null || emailError != null || passwordError != null) {
      state = AuthFormState(nameError: nameError, emailError: emailError, passwordError: passwordError);
      return;
    }
    await _submit(
      () => ref
          .read(authControllerProvider.notifier)
          .signUp(name: name.trim(), email: email.trim(), password: password),
    );
  }

  Future<void> _submit(Future<void> Function() action) async {
    state = const AuthFormState(busy: true);
    try {
      await action();
      if (ref.mounted) state = const AuthFormState();
    } on AuthException catch (error) {
      if (ref.mounted) state = AuthFormState(formError: error.message);
    }
  }

  String? _validateEmail(String email) {
    if (email.trim().isEmpty) return 'Nhập email';
    return _emailPattern.hasMatch(email.trim()) ? null : 'Email không hợp lệ.';
  }
}
