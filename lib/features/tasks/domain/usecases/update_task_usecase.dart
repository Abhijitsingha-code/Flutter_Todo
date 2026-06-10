import '../entities/task.dart';
import '../repositories/task_repository.dart';
import '../../../../core/error/failures.dart';

class UpdateTaskUseCase {
  final TaskRepository _repository;
  UpdateTaskUseCase(this._repository);

  Future<(Task?, Failure?)> call({
    required int taskId,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return _repository.updateTask(
      taskId: taskId,
      title: title,
      description: description,
      isCompleted: isCompleted,
    );
  }
}
