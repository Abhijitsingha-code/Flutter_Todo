import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUseCase _getTasksUseCase;
  final CreateTaskUseCase _createTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;

  TaskBloc({
    required GetTasksUseCase getTasksUseCase,
    required CreateTaskUseCase createTaskUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
  })  : _getTasksUseCase = getTasksUseCase,
        _createTaskUseCase = createTaskUseCase,
        _updateTaskUseCase = updateTaskUseCase,
        _deleteTaskUseCase = deleteTaskUseCase,
        super(const TaskInitial()) {
    on<LoadTasksEvent>(_onLoad);
    on<CreateTaskEvent>(_onCreate);
    on<UpdateTaskEvent>(_onUpdate);
    on<ToggleTaskEvent>(_onToggle);
    on<DeleteTaskEvent>(_onDelete);
  }

  List<Task> get _currentTasks {
    final s = state;
    if (s is TaskLoaded) return s.tasks;
    if (s is TaskOperationSuccess) return s.tasks;
    if (s is TaskError) return s.previousTasks;
    return [];
  }

  Future<void> _onLoad(LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());
    final (tasks, failure) = await _getTasksUseCase();
    if (failure != null) {
      emit(TaskError(failure.message));
    } else {
      emit(TaskLoaded(tasks!));
    }
  }

  Future<void> _onCreate(CreateTaskEvent event, Emitter<TaskState> emit) async {
    final (task, failure) = await _createTaskUseCase(
      title: event.title,
      description: event.description,
    );
    if (failure != null) {
      emit(TaskError(failure.message, previousTasks: _currentTasks));
    } else {
      final updated = [..._currentTasks, task!];
      emit(TaskOperationSuccess(updated, 'Task created!'));
    }
  }

  Future<void> _onUpdate(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    final (task, failure) = await _updateTaskUseCase(
      taskId: event.taskId,
      title: event.title,
      description: event.description,
      isCompleted: event.isCompleted,
    );
    if (failure != null) {
      emit(TaskError(failure.message, previousTasks: _currentTasks));
    } else {
      final updated = _currentTasks
          .map((t) => t.id == task!.id ? task : t)
          .toList();
      emit(TaskOperationSuccess(updated, 'Task updated!'));
    }
  }

  Future<void> _onToggle(ToggleTaskEvent event, Emitter<TaskState> emit) async {
    final task = event.task;
    // Optimistic update
    final optimistic = _currentTasks
        .map((t) => t.id == task.id ? t.copyWith(isCompleted: !t.isCompleted) : t)
        .toList();
    emit(TaskLoaded(optimistic));

    final (updated, failure) = await _updateTaskUseCase(
      taskId: task.id,
      isCompleted: !task.isCompleted,
    );
    if (failure != null) {
      // Rollback
      final rolled = _currentTasks
          .map((t) => t.id == task.id ? task : t)
          .toList();
      emit(TaskError(failure.message, previousTasks: rolled));
    } else {
      final final_ = _currentTasks
          .map((t) => t.id == updated!.id ? updated : t)
          .toList();
      emit(TaskLoaded(final_));
    }
  }

  Future<void> _onDelete(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    final previous = List<Task>.from(_currentTasks);
    final optimistic = _currentTasks.where((t) => t.id != event.taskId).toList();
    emit(TaskLoaded(optimistic));

    final (_, failure) = await _deleteTaskUseCase(event.taskId);
    if (failure != null) {
      emit(TaskError(failure.message, previousTasks: previous));
    }
  }
}
