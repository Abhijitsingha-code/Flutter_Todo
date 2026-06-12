import 'package:flutter/material.dart';
import 'app.dart';
import 'core/di/injection.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  
  // Trigger auth status check on startup to restore the session
  sl<AuthCubit>().checkAuthStatus();
  
  runApp(const App());
}