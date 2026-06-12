import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            _usernameController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 850;

    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/tasks');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppTheme.errorColor,
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthInitial) {
            return const Scaffold(
              backgroundColor: AppTheme.lightBackground,
              body: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.lightPrimary,
                ),
              ),
            );
          }

          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Row(
              children: [
                // Left Panel: Brand & Info (Desktop/Web only)
                if (isWide)
                  Expanded(
                    flex: 11,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFAF6EB),
                            Color(0xFFFAF2DC),
                            Color(0xFFEFE6CA),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        border: Border(
                          right: BorderSide(color: AppTheme.lightBorder, width: 1),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // App Logo
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightPrimaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppTheme.lightBorder),
                                ),
                                child: const Icon(
                                  Icons.checklist_rounded,
                                  color: AppTheme.lightPrimary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'TaskFlow',
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.lightOnSurface,
                                    ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Headline
                          Text(
                            'Your tasks,\nbeautifully\norganized.',
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                  fontSize: 48,
                                  height: 1.15,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 18),
                          // Subtitle
                          Text(
                            'A premium task manager that helps you stay on top of everything — with a clean, focused interface designed to keep you in flow.',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                          ),
                          const SizedBox(height: 48),
                          // Feature Cards
                          _FeatureCard(
                            icon: Icons.shield_outlined,
                            title: 'Secure accounts',
                            subtitle: 'Your data is yours — JWT-protected & private',
                          ),
                          const SizedBox(height: 14),
                          _FeatureCard(
                            icon: Icons.bolt_rounded,
                            title: 'Real-time updates',
                            subtitle: 'Instant feedback as you complete your tasks',
                          ),
                          const SizedBox(height: 14),
                          _FeatureCard(
                            icon: Icons.access_time_rounded,
                            title: 'Stay focused',
                            subtitle: 'Simple, distraction-free task management',
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                // Right Panel: Form
                Expanded(
                  flex: 9,
                  child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 64 : 28,
                        vertical: 32,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Small header logo for mobile
                              if (!isWide) ...[
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.lightPrimaryContainer,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: AppTheme.lightBorder),
                                      ),
                                      child: const Icon(
                                        Icons.checklist_rounded,
                                        color: AppTheme.lightPrimary,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'TaskFlow',
                                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 36),
                              ],

                              Text(
                                'Welcome back',
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 28,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Sign in to continue to TaskFlow',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 36),

                              // Username field label
                              const Text(
                                'USERNAME',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.lightOnSurfaceMuted,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _usernameController,
                                enabled: !isLoading,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  hintText: 'your_username',
                                  prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Username is required';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Password field label
                              const Text(
                                'PASSWORD',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.lightOnSurfaceMuted,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _passwordController,
                                enabled: !isLoading,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _submit(),
                                decoration: InputDecoration(
                                  hintText: 'your_password',
                                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(
                                      () => _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Password is required';
                                  if (v.length < 6) return 'Minimum 6 characters';
                                  return null;
                                },
                              ),

                              const SizedBox(height: 32),

                              // Sign In Button
                              ElevatedButton(
                                onPressed: isLoading ? null : _submit,
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: AppTheme.lightOnSurface,
                                        ),
                                      )
                                    : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.login_rounded, size: 18),
                                          SizedBox(width: 8),
                                          Text('Sign In'),
                                        ],
                                      ),
                              ),

                              const SizedBox(height: 24),

                              // OR Divider
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: AppTheme.lightBorder.withOpacity(0.8),
                                      thickness: 1,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      'OR',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.lightOnSurfaceMuted,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: AppTheme.lightBorder.withOpacity(0.8),
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Register Navigation
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account?",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  TextButton(
                                    onPressed: isLoading
                                        ? null
                                        : () => context.go('/register'),
                                    child: const Row(
                                      children: [
                                        Text('Create one'),
                                        SizedBox(width: 4),
                                        Icon(Icons.arrow_forward_rounded, size: 14),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.lightPrimaryContainer.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.lightBorder.withOpacity(0.5)),
            ),
            child: Icon(icon, color: AppTheme.lightPrimary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightOnSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppTheme.lightOnSurfaceMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
