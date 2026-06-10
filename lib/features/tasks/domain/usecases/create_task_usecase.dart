import '../entities/task.dart';
import '../repositories/task_repository.dart';
import '../../../../core/error/failures.dart';

class CreateTaskUseCase {
  final TaskRepository _repository;
  CreateTaskUseCase(this._repository);

  Future<(Task?, Failure?)> call({
    required String title,
    String? description,
    bool isCompleted = false,
  }) {
    return _repository.createTask(
      title: title,
      description: description,
      isCompleted: isCompleted,
    );
  }
}
