import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_colors.dart';

class CampusTasksCard extends StatelessWidget {
  const CampusTasksCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: AppColors.purpleLight, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.checklist_rounded, color: AppColors.primaryPurple, size: 19),
              ),
              const SizedBox(width: 10),
              const Expanded(child: Text('My study checklist', style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700))),
              TextButton.icon(
                onPressed: () => _addTask(context, state),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add task'),
              ),
            ],
          ),
          if (state.tasks.isEmpty) ...[
            const SizedBox(height: 10),
            const Text('Keep assignments and small deadlines in one place.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ] else ...[
            const SizedBox(height: 8),
            ...state.tasks.map((task) => Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: Checkbox(
                          value: task.isComplete,
                          onChanged: (_) => state.toggleTask(task.id),
                          activeColor: AppColors.primaryPurple,
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(color: task.isComplete ? AppColors.textMuted : AppColors.textPrimary, fontSize: 12, decoration: task.isComplete ? TextDecoration.lineThrough : null),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(DateFormat('d MMM').format(task.dueDate), style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                      IconButton(
                        onPressed: () => state.removeTask(task.id),
                        tooltip: 'Remove task',
                        icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.textMuted),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Future<void> _addTask(BuildContext context, AppState state) async {
    final draft = await showDialog<_TaskDraft>(context: context, builder: (_) => const _AddTaskDialog());
    if (draft != null) state.addTask(draft.title, draft.dueDate);
  }
}

class _TaskDraft {
  final String title;
  final DateTime dueDate;
  const _TaskDraft(this.title, this.dueDate);
}

class _AddTaskDialog extends StatefulWidget {
  const _AddTaskDialog();
  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  final _controller = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Add a study task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              maxLength: 80,
              decoration: InputDecoration(labelText: 'Task or assignment', errorText: _error, counterText: ''),
              onChanged: (_) { if (_error != null) setState(() => _error = null); },
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.event_outlined, size: 18),
              label: Text('Due ${DateFormat('EEE, d MMM').format(_dueDate)}'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: _submit, child: const Text('Add task')),
        ],
      );

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final date = await showDatePicker(context: context, initialDate: _dueDate, firstDate: DateTime(today.year, today.month, today.day), lastDate: DateTime(today.year + 3));
    if (date != null) setState(() => _dueDate = date);
  }

  void _submit() {
    final title = _controller.text.trim();
    if (title.isEmpty) {
      setState(() => _error = 'Enter a task name');
      return;
    }
    Navigator.pop(context, _TaskDraft(title, _dueDate));
  }
}
