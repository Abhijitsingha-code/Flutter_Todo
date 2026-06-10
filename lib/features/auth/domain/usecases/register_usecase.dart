import '../repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

class RegisterUseCase {
  final AuthRepository _repository;
  RegisterUseCase(this._repository);

  Future<(AuthResult?, Failure?)> call(
    String username,
    String email,
    String password,
  ) {
    return _repository.register(username, email, password);
  }
}
