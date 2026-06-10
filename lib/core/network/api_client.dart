import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../shared/services/secure_storage_service.dart';
import '../config/app_config.dart';

Dio createDio(SecureStorageService storageService) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(milliseconds: AppConfig.connectTimeoutMs),
      receiveTimeout: const Duration(milliseconds: AppConfig.receiveTimeoutMs),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(_AuthInterceptor(storageService));
  dio.interceptors.add(_ErrorInterceptor());

  return dio;
}

class _AuthInterceptor extends Interceptor {
  final SecureStorageService _storageService;

  _AuthInterceptor(this._storageService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storageService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('🌐 DioException type=${err.type} status=${err.response?.statusCode} msg=${err.message}');
    debugPrint('🌐 URL: ${err.requestOptions.uri}');
    handler.next(err); // pass through — let datasource handle it
  }
}
