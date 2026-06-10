import '../repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<(AuthResult?, Failure?)> call(String username, String password) {
    return _repository.login(username, password);
  }
}
