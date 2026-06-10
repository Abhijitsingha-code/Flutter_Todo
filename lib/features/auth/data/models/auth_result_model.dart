import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthResultModel {
  final String accessToken;
  final UserModel user;

  const AuthResultModel({required this.accessToken, required this.user});

  factory AuthResultModel.fromJson(Map<String, dynamic> json) {
    return AuthResultModel(
      accessToken: json['access_token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  AuthResult toEntity() {
    return AuthResult(accessToken: accessToken, user: user.toEntity());
  }
}
