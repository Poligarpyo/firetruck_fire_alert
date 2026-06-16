import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/auth_local_datasource_provider.dart';
import '../../features/authentication/data/hive/user_repository.dart';
import '../../features/authentication/domain/auth/auth_controller.dart';
import '../repository/network_repository.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this.ref);
  final Ref ref;

  bool _isLoggingOut = false;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 500 && !_isLoggingOut) {
      _isLoggingOut = true;
      await ref
          .read(authControllerProvider.notifier)
          .logout(message: 'Session expired. You have been logged out.');
    }

    return handler.next(err);
  }
}
