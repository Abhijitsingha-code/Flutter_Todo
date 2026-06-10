import '../entities/task.dart';
import '../repositories/task_repository.dart';
import '../../../../core/error/failures.dart';

class DeleteTaskUseCase {
  final TaskRepository _repository;
  DeleteTaskUseCase(this._repository);

  Future<(Task?, Failure?)> call(int taskId) {
    return _repository.deleteTask(taskId);
  }
}
