import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/enums/auth_status.dart';
import '../../../../data/enums/sg_route.dart';
import '../../../../shared/common/app_snackbar.dart';
import '../../../../shared/common/navigation_keys.dart';
import '../../../../core/storage/auth_local_datasource_provider.dart';
import '../../../../data/repository/network_repository.dart';
part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AuthStatus build() {
    final token = ref.read(authLocalDataSourceProvider).getToken();
    return token != null && token.isNotEmpty
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
  }

  Future<void> logout({String? message}) async {
    await ref.read(authLocalDataSourceProvider).clearAll(); // ✅ one call
    await ref.read(authLocalDataSourceProvider).clearToken();
    await ref.read(authLocalDataSourceProvider).clearLogin();
    ref.read(networkRepositoryProvider.notifier).clearToken();

    state = AuthStatus.unauthenticated;

    // Navigate to login screen directly
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      // Navigate to login without showing splash screen
      context.go('/login');

      // Show snackbar if message is provided
      if (message != null) {
        AppSnackbar.showMessage(
          context,
          message,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  void loginSuccess({required String token}) async {
    state = AuthStatus.authenticated;

    // ✅ Runs inside keepAlive controller — safe from disposal
    await ref.read(authLocalDataSourceProvider).saveToken(token);
    ref.read(networkRepositoryProvider.notifier).setToken(token);

    print('✅ saveToken — ${ref.read(authLocalDataSourceProvider).getToken()}');
    print('✅ saveCode — ${ref.read(authLocalDataSourceProvider).getLogin()}');
    print('✅ setToken called');

    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      context.go(SGRoute.firetruckGPS.route);
    }
  }
}
