import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;
  GetCurrentUserUseCase(this._repository);

  Future<(User?, Failure?)> call() {
    return _repository.getCurrentUser();
  }
}
