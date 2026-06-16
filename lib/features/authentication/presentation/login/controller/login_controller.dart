import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/authentication_repository.dart';
import '../../../domain/auth/auth_controller.dart';
import '../../../domain/login_response.dart';
import 'auth_ui_model.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  AuthUiModel build() {
    return const AuthUiModel();
  }

  void updateLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  // Login Controller - Fixed version
  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    ); // 👈 reset

    try {
      final LoginResponse loginResponse = await ref
          .read(authenticationRepositoryProvider)
          .login(username, password);

      if (loginResponse.token.isNotEmpty) {
        ref
            .read(authControllerProvider.notifier)
            .loginSuccess(token: loginResponse.token);
        state = state.copyWith(isLoading: false, isSuccess: true); // 👈
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Login failed: Empty token received', // 👈
        );
      }
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString().replaceFirst('Exception: ', ''), // 👈
      );
    }
  }
}
