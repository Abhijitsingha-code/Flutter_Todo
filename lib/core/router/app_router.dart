import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/tasks/presentation/bloc/task_bloc.dart';
import '../../features/tasks/presentation/bloc/task_event.dart';
import '../../features/tasks/presentation/pages/task_list_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) async {
    final authCubit = sl<AuthCubit>();
    final authState = authCubit.state;

    final isAuthRoute =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    if (authState is AuthAuthenticated && isAuthRoute) {
      return '/tasks';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const RegisterPage(),
      ),
    ),
    GoRoute(
      path: '/tasks',
      name: 'tasks',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<AuthCubit>()..checkAuthStatus()),
          BlocProvider(
            create: (_) => sl<TaskBloc>()..add(const LoadTasksEvent()),
          ),
        ],
        child: const TaskListPage(),
      ),
    ),
  ],
);
