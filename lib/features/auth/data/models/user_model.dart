import '../../domain/entities/user.dart';

class UserModel {
  final int id;
  final String username;
  final String email;
  final String createdAt;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  User toEntity() {
    return User(
      id: id,
      username: username,
      email: email,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
    );
  }
}
