import '../../domain/entities/task.dart';

class TaskModel {
  final int id;
  final String title;
  final String? description;
  final bool isCompleted;
  final int userId;
  final String createdAt;
  final String updatedAt;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['is_completed'] as bool,
      userId: json['user_id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      userId: userId,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(updatedAt) ?? DateTime.now(),
    );
  }
}
