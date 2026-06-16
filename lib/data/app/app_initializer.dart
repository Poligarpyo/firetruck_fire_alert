import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/storage/auth_local_datasource_provider.dart';
import '../../features/authentication/domain/auth/auth_controller.dart';
import '../repository/network_repository.dart';

part 'app_initializer.g.dart';

@riverpod
Future<void> appInitializer(Ref ref) async {
  final authLocal = ref.read(authLocalDataSourceProvider);
  final token = authLocal.getToken();
  final login = authLocal.getLogin();
  if (token == null || login == null) return;

  try {
    await ref.read(networkRepositoryProvider).post(
      '/ClientCabinetBasic/GetAccountInformation',
      data: {
        'login': login,
        'token': token,
      },
    );

    ref.read(networkRepositoryProvider.notifier).setToken(token);
  } catch (_) {
    await ref
        .read(authControllerProvider.notifier)
        .logout(message: 'Session expired. You have been logged out.');
  }
}
