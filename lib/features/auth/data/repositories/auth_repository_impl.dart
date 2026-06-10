import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/services/secure_storage_service.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remote;
  final SecureStorageService _storage;

  AuthRepositoryImpl(this._remote, this._storage);

  @override
  Future<(AuthResult?, Failure?)> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      final model = await _remote.register(username, email, password);
      final entity = model.toEntity();
      await _storage.saveToken(entity.accessToken);
      return (entity, null);
    } on UnauthorizedException catch (e) {
      return (null, UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return (null, ServerFailure(e.message));
    } on NetworkException catch (e) {
      return (null, NetworkFailure(e.message));
    } catch (_) {
      return (null, const UnknownFailure());
    }
  }

  @override
  Future<(AuthResult?, Failure?)> login(
    String username,
    String password,
  ) async {
    try {
      final model = await _remote.login(username, password);
      final entity = model.toEntity();
      await _storage.saveToken(entity.accessToken);
      return (entity, null);
    } on UnauthorizedException catch (e) {
      return (null, UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return (null, ServerFailure(e.message));
    } on NetworkException catch (e) {
      return (null, NetworkFailure(e.message));
    } catch (_) {
      return (null, const UnknownFailure());
    }
  }

  @override
  Future<(User?, Failure?)> getCurrentUser() async {
    try {
      final model = await _remote.getCurrentUser();
      return (model.toEntity(), null);
    } on UnauthorizedException catch (e) {
      return (null, UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return (null, ServerFailure(e.message));
    } on NetworkException catch (e) {
      return (null, NetworkFailure(e.message));
    } catch (_) {
      return (null, const UnknownFailure());
    }
  }

  @override
  Future<void> logout() async {
    await _storage.deleteToken();
  }
}
