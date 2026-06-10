import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/task_tile.dart';
import '../pages/task_form_page.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  String _selectedFilter = 'all'; // 'all', 'pending', 'completed'
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openForm(BuildContext context, {Task? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<TaskBloc>(),
        child: TaskFormPage(task: task),
      ),
    );
  }

  List<Task> _getFilteredTasks(List<Task> tasks) {
    return tasks.where((task) {
      // Filter by status tab
      if (_selectedFilter == 'pending' && task.isCompleted) return false;
      if (_selectedFilter == 'completed' && !task.isCompleted) return false;

      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        final title = task.title.toLowerCase();
        final desc = (task.description ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || desc.contains(query);
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightContentBg,
      body: MultiBlocListener(
        listeners: [
          BlocListener<TaskBloc, TaskState>(
            listener: (context, state) {
              if (state is TaskError) {
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
              } else if (state is TaskOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppTheme.lightSuccess,
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          state.message,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthUnauthenticated) {
                context.go('/login');
              }
            },
          ),
        ],
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final username = authState is AuthAuthenticated ? authState.user.username : '';
            final email = authState is AuthAuthenticated ? authState.user.email : '';
            final initialLetter = username.isNotEmpty ? username[0].toUpperCase() : 'A';

            return BlocBuilder<TaskBloc, TaskState>(
              builder: (context, taskState) {
                final tasks = _getTasksList(taskState);
                final isLoading = taskState is TaskLoading;
                final filteredTasks = _getFilteredTasks(tasks);

                final totalCount = tasks.length;
                final completedCount = tasks.where((t) => t.isCompleted).length;
                final pendingCount = tasks.where((t) => !t.isCompleted).length;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 850;

                    if (isWide) {
                      return Row(
                        children: [
                          // Left Sidebar
                          _buildSidebar(context, username, email, initialLetter, totalCount, pendingCount, completedCount),
                          // Right Content
                          Expanded(
                            child: _buildMainContent(context, filteredTasks, isLoading, totalCount, completedCount, pendingCount, isWide),
                          ),
                        ],
                      );
                    } else {
                      // Mobile View
                      return Scaffold(
                        backgroundColor: AppTheme.lightContentBg,
                        appBar: AppBar(
                          title: const Row(
                            children: [
                              Icon(Icons.checklist_rounded, color: AppTheme.lightPrimary),
                              SizedBox(width: 8),
                              Text('TaskFlow', style: TextStyle(fontWeight: FontWeight.w800)),
                            ],
                          ),
                          backgroundColor: Colors.white,
                          elevation: 1,
                          shadowColor: AppTheme.lightBorder,
                        ),
                        drawer: Drawer(
                          backgroundColor: Colors.white,
                          child: _buildSidebar(context, username, email, initialLetter, totalCount, pendingCount, completedCount, inDrawer: true),
                        ),
                        body: _buildMainContent(context, filteredTasks, isLoading, totalCount, completedCount, pendingCount, isWide),
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<Task> _getTasksList(TaskState state) {
    if (state is TaskLoaded) return state.tasks;
    if (state is TaskOperationSuccess) return state.tasks;
    if (state is TaskError) return state.previousTasks;
    return [];
  }

  // Sidebar Widget
  Widget _buildSidebar(
    BuildContext context,
    String username,
    String email,
    String initialLetter,
    int total,
    int pending,
    int completed, {
    bool inDrawer = false,
  }) {
    return Container(
      width: inDrawer ? null : 260,
      decoration: BoxDecoration(
        color: Colors.white,
        border: inDrawer
            ? null
            : const Border(
                right: BorderSide(color: AppTheme.lightBorder, width: 1),
              ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!inDrawer) ...[
            // Logo
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.lightPrimaryContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.lightBorder),
                  ),
                  child: const Icon(
                    Icons.checklist_rounded,
                    color: AppTheme.lightPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'TaskFlow',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.lightOnSurface,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],

          // User Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.lightContentBg.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.lightBorder.withOpacity(0.8)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFE5D5B8),
                  child: Text(
                    initialLetter,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6E531B),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username.isNotEmpty ? username : 'Abhijit',
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.lightOnSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        email.isNotEmpty ? email : 'your_email@example.com',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.lightOnSurfaceMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // Navigation Links
          _buildSidebarNavItem(
            label: 'All Tasks',
            icon: Icons.list_alt_rounded,
            count: total,
            isActive: _selectedFilter == 'all',
            onTap: () {
              setState(() => _selectedFilter = 'all');
              if (inDrawer) Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
          _buildSidebarNavItem(
            label: 'Pending',
            icon: Icons.schedule_rounded,
            count: pending,
            isActive: _selectedFilter == 'pending',
            onTap: () {
              setState(() => _selectedFilter = 'pending');
              if (inDrawer) Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
          _buildSidebarNavItem(
            label: 'Completed',
            icon: Icons.check_circle_outline_rounded,
            count: completed,
            isActive: _selectedFilter == 'completed',
            onTap: () {
              setState(() => _selectedFilter = 'completed');
              if (inDrawer) Navigator.pop(context);
            },
          ),

          const Spacer(),

          // Sign Out Button
          OutlinedButton(
            onPressed: () => context.read<AuthCubit>().logout(),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 46),
              side: const BorderSide(color: AppTheme.lightBorder),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              foregroundColor: AppTheme.lightOnSurface,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout_rounded, size: 16),
                SizedBox(width: 8),
                Text(
                  'Sign Out',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarNavItem({
    required String label,
    required IconData icon,
    required int count,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.lightPrimaryContainer.withOpacity(0.8) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: isActive
              ? Border.all(color: AppTheme.lightPrimary.withOpacity(0.5), width: 1)
              : Border.all(color: Colors.transparent, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? AppTheme.lightPrimary : AppTheme.lightOnSurfaceMuted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? AppTheme.lightPrimary : AppTheme.lightOnSurface,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.lightPrimary.withOpacity(0.2) : AppTheme.lightBorder.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isActive ? AppTheme.lightPrimary : AppTheme.lightOnSurfaceMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Main Content Widget
  Widget _buildMainContent(
    BuildContext context,
    List<Task> filteredTasks,
    bool isLoading,
    int total,
    int completed,
    int pending,
    bool isWide,
  ) {
    String contentTitle = 'All Tasks';
    String contentSubtitle = 'Everything you need to get done';
    if (_selectedFilter == 'pending') {
      contentTitle = 'Pending Tasks';
      contentSubtitle = 'Tasks currently in progress';
    } else if (_selectedFilter == 'completed') {
      contentTitle = 'Completed Tasks';
      contentSubtitle = 'Your archive of completed tasks';
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 40 : 16,
        vertical: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contentTitle,
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contentSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _openForm(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 42),
                  backgroundColor: AppTheme.lightPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: AppTheme.lightPrimary.withOpacity(0.3),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16, color: AppTheme.lightOnSurface),
                    SizedBox(width: 6),
                    Text(
                      'New Task',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Divider line
          Divider(color: AppTheme.lightBorder.withOpacity(0.6), thickness: 1),
          const SizedBox(height: 24),

          // Search & Filter bar
          Row(
            children: [
              // Search Input
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.lightBorder),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: AppTheme.lightOnSurfaceMuted, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) {
                            setState(() => _searchQuery = val);
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search tasks...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(fontSize: 13.5),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          child: const Icon(Icons.close_rounded, color: AppTheme.lightOnSurfaceMuted, size: 16),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Filter Chips
              _buildFilterChip('All', 'all'),
              const SizedBox(width: 6),
              _buildFilterChip('Pending', 'pending'),
              const SizedBox(width: 6),
              _buildFilterChip('Done', 'completed'),
            ],
          ),
          const SizedBox(height: 24),

          // Loading & Task List Content
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 64),
              child: Center(child: CircularProgressIndicator(color: AppTheme.lightPrimary)),
            )
          else if (filteredTasks.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 72),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.lightBorder),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_turned_in_outlined,
                    size: 56,
                    color: AppTheme.lightOnSurfaceMuted.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No tasks found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightOnSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Try creating a new task to get started',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.lightOnSurfaceMuted,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return TaskTile(
                  key: ValueKey(task.id),
                  task: task,
                  onToggle: () => context.read<TaskBloc>().add(ToggleTaskEvent(task)),
                  onEdit: () => _openForm(context, task: task),
                  onDelete: () => context.read<TaskBloc>().add(DeleteTaskEvent(task.id)),
                );
              },
            ),
        ],
      ),
    );
  }

  // Filter Chip Widget
  Widget _buildFilterChip(String label, String value) {
    final isActive = _selectedFilter == value;
    return InkWell(
      onTap: () {
        setState(() => _selectedFilter = value);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.lightPrimary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppTheme.lightPrimary : AppTheme.lightBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : AppTheme.lightOnSurface,
          ),
        ),
      ),
    );
  }
}
