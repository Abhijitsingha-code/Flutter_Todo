import 'dart:async';
import 'package:flutter/material.dart';
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
import '../theme/app_theme.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic_) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/loading',
  refreshListenable: GoRouterRefreshStream(sl<AuthCubit>().stream),
  redirect: (context, state) async {
    final authCubit = sl<AuthCubit>();
    final authState = authCubit.state;

    final isAuthRoute =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';
    final isLoadingRoute = state.matchedLocation == '/loading';

    if (authState is AuthInitial || authState is AuthLoading) {
      if (!isLoadingRoute) {
        return '/loading';
      }
      return null;
    }

    if (authState is AuthAuthenticated) {
      if (isAuthRoute || isLoadingRoute) {
        return '/tasks';
      }
    } else if (authState is AuthUnauthenticated) {
      if (!isAuthRoute || isLoadingRoute) {
        return '/login';
      }
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/loading',
      name: 'loading',
      builder: (context, state) => const Scaffold(
        backgroundColor: AppTheme.lightBackground,
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.lightPrimary,
          ),
        ),
      ),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => BlocProvider.value(
        value: sl<AuthCubit>(),
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => BlocProvider.value(
        value: sl<AuthCubit>(),
        child: const RegisterPage(),
      ),
    ),
    GoRoute(
      path: '/tasks',
      name: 'tasks',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sl<AuthCubit>()),
          BlocProvider(
            create: (_) => sl<TaskBloc>()..add(const LoadTasksEvent()),
          ),
        ],
        child: const TaskListPage(),
      ),
    ),
  ],
);
