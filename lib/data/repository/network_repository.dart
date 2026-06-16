import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:riverpod/riverpod.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/common/app_snackbar.dart';
import '../../shared/common/navigation_keys.dart';
import '../../shared/constants/endpoints.dart';
import '../../core/storage/auth_local_datasource_provider.dart';
import '../../features/authentication/data/hive/user_repository.dart';
import '../../features/authentication/domain/auth/auth_controller.dart';
import '../../router/app_router.dart';
import '../auth/auth_interceptor.dart';

part 'network_repository.g.dart';

/// A repository class that extends _$NetworkRepository to handle network-related operations.
/// This class serves as an abstraction layer for managing network requests and responses,
/// providing a clean interface for the rest of the application to interact with network data.
@riverpod
class NetworkRepository extends _$NetworkRepository {
  @override
  Dio build() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.peanutUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          // 'x-api-key': Endpoints.apiKey,
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('➡️ Request [${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(
            '✅ Response [${response.statusCode}] => DATA: ${response.data}',
          );
          return handler.next(response);
        },
        onError: (DioException err, handler) async {
          final status = err.response?.statusCode;

          if (status == 500) {
            await _handleUnauthorized();
          }
          return handler.next(err);
        },
      ),
    );

    dio.interceptors.add(AuthInterceptor(ref));

    return dio;
  }

  void setToken(String token) {
    state.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearToken() {
    state.options.headers.remove('Authorization');
  }

  Future<void> _handleUnauthorized() async {
    final ref = this.ref;
    clearToken();

    // Logout AND show snackbar (once)
    await ref
        .read(authControllerProvider.notifier)
        .logout(message: 'Session expired. You have been logged out.');
  }
}
