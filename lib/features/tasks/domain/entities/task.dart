class Task {
  final int id;
  final String title;
  final String? description;
  final bool isCompleted;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
