import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/task_model.dart';

class TaskRemoteDatasource {
  final Dio _dio;

  TaskRemoteDatasource(this._dio);

  Future<List<TaskModel>> getTasks({int skip = 0, int limit = 100}) async {
    try {
      final response = await _dio.get(
        '/tasks/',
        queryParameters: {'skip': skip, 'limit': limit},
      );
      final list = response.data as List<dynamic>;
      return list
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<TaskModel> getTask(int taskId) async {
    try {
      final response = await _dio.get('/tasks/$taskId');
      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<TaskModel> createTask({
    required String title,
    String? description,
    bool isCompleted = false,
  }) async {
    try {
      final response = await _dio.post(
        '/tasks/',
        data: {
          'title': title,
          if (description != null) 'description': description,
          'is_completed': isCompleted,
        },
      );
      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<TaskModel> updateTask({
    required int taskId,
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (isCompleted != null) body['is_completed'] = isCompleted;

      final response = await _dio.put('/tasks/$taskId', data: body);
      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<TaskModel> deleteTask(int taskId) async {
    try {
      final response = await _dio.delete('/tasks/$taskId');
      return TaskModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  void _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message =
        e.response?.data?['detail']?.toString() ?? e.message ?? 'Unknown error';
    if (statusCode == 401) throw UnauthorizedException(message);
    if (statusCode == 404) throw NotFoundException(message);
    throw ServerException(message: message, statusCode: statusCode);
  }
}
