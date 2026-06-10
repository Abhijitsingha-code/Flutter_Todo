import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final AuthRepository _authRepository;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required AuthRepository authRepository,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _authRepository = authRepository,
        super(const AuthInitial());

  Future<void> checkAuthStatus() async {
    final (user, failure) = await _getCurrentUserUseCase();
    if (failure != null) {
      emit(const AuthUnauthenticated());
    } else {
      emit(AuthAuthenticated(user!));
    }
  }

  Future<void> login(String username, String password) async {
    emit(const AuthLoading());
    final (result, failure) = await _loginUseCase(username, password);
    if (failure != null) {
      debugPrint('❌ Login error: ${failure.message}');
      emit(AuthError(failure.message));
    } else {
      debugPrint('✅ Login success: user=${result!.user.username}, token=${result.accessToken}');
      emit(AuthAuthenticated(result.user));
    }
  }

  Future<void> register(
    String username,
    String email,
    String password,
  ) async {
    emit(const AuthLoading());
    final (result, failure) = await _registerUseCase(username, email, password);
    if (failure != null) {
      debugPrint('❌ Register error: ${failure.message}');
      emit(AuthError(failure.message));
    } else {
      debugPrint('✅ Register success: user=${result!.user.username}, token=${result.accessToken}');
      emit(AuthAuthenticated(result.user));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(const AuthUnauthenticated());
  }
}
