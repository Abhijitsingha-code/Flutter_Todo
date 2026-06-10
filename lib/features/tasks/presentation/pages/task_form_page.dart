import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';

class TaskFormPage extends StatefulWidget {
  final Task? task; // null = create mode, non-null = edit mode

  const TaskFormPage({super.key, this.task});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late bool _isCompleted;
  bool _isLoading = false;

  bool get _isEditMode => widget.task != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController = TextEditingController(
      text: widget.task?.description ?? '',
    );
    _isCompleted = widget.task?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    if (_isEditMode) {
      context.read<TaskBloc>().add(
            UpdateTaskEvent(
              taskId: widget.task!.id,
              title: _titleController.text.trim(),
              description: _descController.text.trim().isEmpty
                  ? null
                  : _descController.text.trim(),
              isCompleted: _isCompleted,
            ),
          );
    } else {
      context.read<TaskBloc>().add(
            CreateTaskEvent(
              title: _titleController.text.trim(),
              description: _descController.text.trim().isEmpty
                  ? null
                  : _descController.text.trim(),
            ),
          );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.mutedColor.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              _isEditMode ? 'Edit Task' : 'New Task',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 24),

            // Title
            TextFormField(
              controller: _titleController,
              autofocus: true,
              maxLength: 100,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Task title *',
                prefixIcon: Icon(Icons.title_rounded, size: 20),
                counterText: '',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Title is required';
                if (v.trim().length > 100) return 'Max 100 characters';
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descController,
              maxLines: 3,
              maxLength: 500,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 48),
                  child: Icon(Icons.notes_rounded, size: 20),
                ),
                alignLabelWithHint: true,
                counterText: '',
              ),
            ),

            const SizedBox(height: 16),

            // Is Completed toggle (only in edit mode)
            if (_isEditMode) ...[
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightContentBg.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.lightBorder),
                ),
                child: SwitchListTile(
                  title: const Text(
                    'Mark as completed',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    _isCompleted ? 'Task is done ✓' : 'Task is pending',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  value: _isCompleted,
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onChanged: (v) => setState(() => _isCompleted = v),
                ),
              ),
              const SizedBox(height: 20),
            ],

            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppTheme.lightOnSurface,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isEditMode ? Icons.save_outlined : Icons.add_rounded,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(_isEditMode ? 'Save Changes' : 'Create Task'),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
