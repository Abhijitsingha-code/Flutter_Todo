import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[date.month - 1];
    return '$month ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.errorColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.errorColor.withOpacity(0.25)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline_rounded, color: AppTheme.errorColor, size: 24),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: AppTheme.errorColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Delete Task',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text('Are you sure you want to delete "${task.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel', style: TextStyle(color: AppTheme.lightOnSurfaceMuted)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.errorColor,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      child: Card(
        color: Colors.white,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppTheme.lightBorder, width: 1),
        ),
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left accent border stripe for completed tasks
                  Container(
                    width: 4,
                    color: task.isCompleted ? AppTheme.successColor : Colors.transparent,
                  ),
                  const SizedBox(width: 16),

                  // Main Checkbox & Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Circular Checkbox
                          GestureDetector(
                            onTap: onToggle,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: task.isCompleted
                                    ? AppTheme.primaryColor
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: task.isCompleted
                                      ? AppTheme.primaryColor
                                      : const Color(0xFFC0BCB3),
                                  width: 2,
                                ),
                              ),
                              child: task.isCompleted
                                  ? const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Text content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: task.isCompleted
                                        ? AppTheme.lightOnSurfaceMuted
                                        : AppTheme.lightOnSurface,
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                if (task.description != null &&
                                    task.description!.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    task.description!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.lightOnSurfaceMuted,
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                const SizedBox(height: 12),

                                // Badge & Date Row
                                Row(
                                  children: [
                                    // Status Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: task.isCompleted
                                            ? const Color(0xFFD1FAE5) // light green
                                            : const Color(0xFFFEF3C7), // light amber
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        task.isCompleted ? 'DONE' : 'PENDING',
                                        style: TextStyle(
                                          color: task.isCompleted
                                              ? const Color(0xFF065F46) // dark green
                                              : const Color(0xFF92400E), // dark amber
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),

                                    // Formatted Date
                                    Text(
                                      _formatDate(task.createdAt),
                                      style: const TextStyle(
                                        color: AppTheme.lightOnSurfaceMuted,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Swipe/chevron indicator or actions (optional, let's keep it simple)
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
