import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../services/parse_service.dart';
import '../screens/task_form_screen.dart';

class TaskTile extends StatefulWidget {
  final ParseObject task;
  final VoidCallback? onChanged;
  const TaskTile({super.key, required this.task, this.onChanged});
  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool _loading = false;

  Future<void> _toggleDone(bool? newVal) async {
    if (newVal == null) return;
    setState(() => _loading = true);
    final id = widget.task.objectId!;
    final title = widget.task.get<String>('title') ?? '';
    final desc = widget.task.get<String>('description') ?? '';
    final status =
        newVal ? 'completed' : (widget.task.get<String>('status') ?? 'open');
    final resp = await ParseService.updateTask(
      id,
      title,
      desc,
      status == 'completed',
      status: status,
    );
    setState(() => _loading = false);
    if (resp.success) {
      widget.onChanged?.call();
    } else if (mounted)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resp.error?.message ?? 'Update failed')),
      );
  }

  Future<void> _delete() async {
    final conf = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete Task?'),
        content: const Text('This will permanently delete the task.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(c).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (conf != true) return;
    setState(() => _loading = true);
    final resp = await ParseService.deleteTask(widget.task.objectId!);
    setState(() => _loading = false);
    if (resp.success) {
      widget.onChanged?.call();
    } else if (mounted)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resp.error?.message ?? 'Delete failed')),
      );
  }

  void _edit() async {
    final updated = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TaskFormScreen(task: widget.task)),
    );
    if (updated == true) widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.task.get<String>('title') ?? '(no title)';
    final desc = widget.task.get<String>('description') ?? '';
    final status = widget.task.get<String>('status') ??
        (widget.task.get<bool>('done') == true ? 'completed' : 'open');
    final done = status == 'completed';

    DateTime? completedAt;
    try {
      final raw = widget.task.get('completedAt');
      if (raw is DateTime) {
        completedAt = raw;
      } else if (raw is Map && raw['iso'] != null)
        completedAt = DateTime.parse(raw['iso']);
    } catch (_) {
      completedAt = null;
    }

    String subtitleText = desc;
    if (done && completedAt != null) {
      final s = completedAt.toLocal().toString().split('.').first;
      subtitleText = '${desc.isEmpty ? '' : desc + '\n'}Completed: $s';
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: _loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(),
              )
            : Checkbox(value: done, onChanged: _toggleDone),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  decoration:
                      done ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: done
                    ? Colors.green.shade100
                    : (status == 'pending'
                        ? Colors.orange.shade100
                        : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status.toUpperCase(),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        subtitle: subtitleText.isEmpty
            ? null
            : Text(subtitleText, maxLines: 3, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: _edit, icon: const Icon(Icons.edit)),
            IconButton(onPressed: _delete, icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
