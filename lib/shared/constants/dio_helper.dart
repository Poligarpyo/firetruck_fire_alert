// lib/core/helpers/dio_helper.dart
import 'package:dio/dio.dart';

import 'endpoints.dart';

class DioHelper {
  // Singleton pattern
  static Dio? _dio;

  static Dio getInstance() {
    if (_dio != null) return _dio!;

    _dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.peanutUrl, 
        connectTimeout: const Duration(milliseconds: Endpoints.connectionTimeout),
        receiveTimeout: const Duration(milliseconds: Endpoints.receiveTimeout),
        headers: <String, dynamic>{
          'Content-Type': 'application/json-patch+json',
          'Accept': 'application/json/*/*',
        },
      ),
    );

    // Add interceptors (optional but useful)
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Example: Add token dynamically
          // options.headers['Authorization'] = 'Bearer $token';
          print('➡️ Request [${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(
              '✅ Response [${response.statusCode}] => DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          
          print('❌ Error [${e.response?.statusCode}] => MESSAGE: ${e.message}');
          return handler.next(e);
        },
      ),
    );

    return _dio!;
  }

  // Optional helper methods for simple requests
  // ignore: strict_raw_type, always_specify_types
  static Future<Response> get(String path,
      {Map<String, dynamic>? queryParams}) async {
    return await getInstance().get(path, queryParameters: queryParams);
  }

  // ignore: strict_raw_type, always_specify_types
  static Future<Response> post(String path, {dynamic data}) async {
    return await getInstance().post(path, data: data);
  }
   // ignore: strict_raw_type, always_specify_types 
  static Future<Response> put(String path, {dynamic data}) async {
    return await getInstance().put(path, data: data);
  }
  // ignore: strict_raw_type, always_specify_types
  static Future<Response> delete(String path) async {
    return await getInstance().delete(path);
  }
}
