import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/exceptions.dart';
import '../models/auth_result_model.dart';
import '../models/user_model.dart';

class AuthRemoteDatasource {
  final Dio _dio;

  AuthRemoteDatasource(this._dio);

  Future<AuthResultModel> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {'username': username, 'email': email, 'password': password},
      );
      return AuthResultModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<AuthResultModel> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      return AuthResultModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth/me');
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  void _handleDioError(DioException e) {
    debugPrint('━━━━━━━━━━ Auth DioException ━━━━━━━━━━');
    debugPrint('  type   : ${e.type}');
    debugPrint('  message: ${e.message}');
    debugPrint('  status : ${e.response?.statusCode}');
    debugPrint('  data   : ${e.response?.data}');
    debugPrint('  url    : ${e.requestOptions.uri}');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    // Connection-level errors
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      throw const NetworkException('Cannot connect to server. Check your network or server.');
    }

    final statusCode = e.response?.statusCode;
    final message =
        e.response?.data?['detail']?.toString() ?? e.message ?? 'Unknown error';
    if (statusCode == 401) throw UnauthorizedException(message);
    if (statusCode == 404) throw NotFoundException(message);
    throw ServerException(message: message, statusCode: statusCode);
  }
}
