import '../entities/task.dart';
import '../../../../core/error/failures.dart';

abstract class TaskRepository {
  Future<(List<Task>?, Failure?)> getTasks({int skip = 0, int limit = 100});
  Future<(Task?, Failure?)> getTask(int taskId);
  Future<(Task?, Failure?)> createTask({
    required String title,
    String? description,
    bool isCompleted = false,
  });
  Future<(Task?, Failure?)> updateTask({
    required int taskId,
    String? title,
    String? description,
    bool? isCompleted,
  });
  Future<(Task?, Failure?)> deleteTask(int taskId);
}
