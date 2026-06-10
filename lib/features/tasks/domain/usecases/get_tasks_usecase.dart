import '../entities/task.dart';
import '../repositories/task_repository.dart';
import '../../../../core/error/failures.dart';

class GetTasksUseCase {
  final TaskRepository _repository;
  GetTasksUseCase(this._repository);

  Future<(List<Task>?, Failure?)> call({int skip = 0, int limit = 100}) {
    return _repository.getTasks(skip: skip, limit: limit);
  }
}
