import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../datasources/task_remote_datasource.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDatasource _remote;

  TaskRepositoryImpl(this._remote);

  @override
  Future<(List<Task>?, Failure?)> getTasks({
    int skip = 0,
    int limit = 100,
  }) async {
    try {
      final models = await _remote.getTasks(skip: skip, limit: limit);
      return (models.map((m) => m.toEntity()).toList(), null);
    } on UnauthorizedException catch (e) {
      return (null, UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return (null, ServerFailure(e.message));
    } on NetworkException catch (e) {
      return (null, NetworkFailure(e.message));
    } catch (_) {
      return (null, const UnknownFailure());
    }
  }

  @override
  Future<(Task?, Failure?)> getTask(int taskId) async {
    try {
      final model = await _remote.getTask(taskId);
      return (model.toEntity(), null);
    } on NotFoundException catch (e) {
      return (null, NotFoundFailure(e.message));
    } on UnauthorizedException catch (e) {
      return (null, UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return (null, ServerFailure(e.message));
    } on NetworkException catch (e) {
      return (null, NetworkFailure(e.message));
    } catch (_) {
      return (null, const UnknownFailure());
    }
  }

  @override
  Future<(Task?, Failure?)> createTask({
    required String title,
    String? description,
    bool isCompleted = false,
  }) async {
    try {
      final model = await _remote.createTask(
        title: title,
        description: description,
        isCompleted: isCompleted,
      );
      return (model.toEntity(), null);
    } on UnauthorizedException catch (e) {
      return (null, UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return (null, ServerFailure(e.message));
    } on NetworkException catch (e) {
      return (null, NetworkFailure(e.message));
    } catch (_) {
      return (null, const UnknownFailure());
    }
  }

  @override
  Future<(Task?, Failure?)> updateTask({
    required int taskId,
    String? title,
    String? description,
    bool? isCompleted,
  }) async {
    try {
      final model = await _remote.updateTask(
        taskId: taskId,
        title: title,
        description: description,
        isCompleted: isCompleted,
      );
      return (model.toEntity(), null);
    } on NotFoundException catch (e) {
      return (null, NotFoundFailure(e.message));
    } on UnauthorizedException catch (e) {
      return (null, UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return (null, ServerFailure(e.message));
    } on NetworkException catch (e) {
      return (null, NetworkFailure(e.message));
    } catch (_) {
      return (null, const UnknownFailure());
    }
  }

  @override
  Future<(Task?, Failure?)> deleteTask(int taskId) async {
    try {
      final model = await _remote.deleteTask(taskId);
      return (model.toEntity(), null);
    } on NotFoundException catch (e) {
      return (null, NotFoundFailure(e.message));
    } on UnauthorizedException catch (e) {
      return (null, UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return (null, ServerFailure(e.message));
    } on NetworkException catch (e) {
      return (null, NetworkFailure(e.message));
    } catch (_) {
      return (null, const UnknownFailure());
    }
  }
}
