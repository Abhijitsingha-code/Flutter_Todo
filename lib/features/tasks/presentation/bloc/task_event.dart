import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {
  const LoadTasksEvent();
}

class CreateTaskEvent extends TaskEvent {
  final String title;
  final String? description;

  const CreateTaskEvent({required this.title, this.description});

  @override
  List<Object?> get props => [title, description];
}

class UpdateTaskEvent extends TaskEvent {
  final int taskId;
  final String? title;
  final String? description;
  final bool? isCompleted;

  const UpdateTaskEvent({
    required this.taskId,
    this.title,
    this.description,
    this.isCompleted,
  });

  @override
  List<Object?> get props => [taskId, title, description, isCompleted];
}

class ToggleTaskEvent extends TaskEvent {
  final Task task;
  const ToggleTaskEvent(this.task);

  @override
  List<Object?> get props => [task.id];
}

class DeleteTaskEvent extends TaskEvent {
  final int taskId;
  const DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}
