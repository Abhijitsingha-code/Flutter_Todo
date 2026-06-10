import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {
  const TaskInitial();
}

class TaskLoading extends TaskState {
  const TaskLoading();
}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  const TaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];

  int get completedCount => tasks.where((t) => t.isCompleted).length;
  int get pendingCount => tasks.where((t) => !t.isCompleted).length;
}

class TaskOperationSuccess extends TaskState {
  final List<Task> tasks;
  final String message;
  const TaskOperationSuccess(this.tasks, this.message);

  @override
  List<Object?> get props => [tasks, message];
}

class TaskError extends TaskState {
  final String message;
  final List<Task> previousTasks;
  const TaskError(this.message, {this.previousTasks = const []});

  @override
  List<Object?> get props => [message];
}
