import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../network/api_client.dart';
import '../../shared/services/secure_storage_service.dart';

// Auth
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

// Tasks
import '../../features/tasks/data/datasources/task_remote_datasource.dart';
import '../../features/tasks/data/repositories/task_repository_impl.dart';
import '../../features/tasks/domain/repositories/task_repository.dart';
import '../../features/tasks/domain/usecases/get_tasks_usecase.dart';
import '../../features/tasks/domain/usecases/create_task_usecase.dart';
import '../../features/tasks/domain/usecases/update_task_usecase.dart';
import '../../features/tasks/domain/usecases/delete_task_usecase.dart';
import '../../features/tasks/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Infrastructure ──────────────────────────────────────────────
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(sl()),
  );
  sl.registerLazySingleton<Dio>(
    () => createDio(sl()),
  );

  // ── Auth ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      registerUseCase: sl(),
      getCurrentUserUseCase: sl(),
      authRepository: sl(),
    ),
  );

  // ── Tasks ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<TaskRemoteDatasource>(
    () => TaskRemoteDatasource(sl()),
  );
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetTasksUseCase(sl()));
  sl.registerLazySingleton(() => CreateTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));
  sl.registerFactory(
    () => TaskBloc(
      getTasksUseCase: sl(),
      createTaskUseCase: sl(),
      updateTaskUseCase: sl(),
      deleteTaskUseCase: sl(),
    ),
  );
}
