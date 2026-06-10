import '../entities/user.dart';
import '../../../../core/error/failures.dart';

class AuthResult {
  final String accessToken;
  final User user;

  const AuthResult({required this.accessToken, required this.user});
}

abstract class AuthRepository {
  Future<(AuthResult?, Failure?)> register(
    String username,
    String email,
    String password,
  );

  Future<(AuthResult?, Failure?)> login(String username, String password);

  Future<(User?, Failure?)> getCurrentUser();

  Future<void> logout();
}
