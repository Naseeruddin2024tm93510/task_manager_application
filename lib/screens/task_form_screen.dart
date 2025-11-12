import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../services/parse_service.dart';

class TaskFormScreen extends StatefulWidget {
  final ParseObject? task;
  const TaskFormScreen({super.key, this.task});
  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  String _status = 'open';
  bool _loading = false;

  final List<String> _statuses = ['open', 'pending', 'completed'];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title.text = widget.task!.get<String>('title') ?? '';
      _desc.text = widget.task!.get<String>('description') ?? '';
      _status = widget.task!.get<String>('status') ?? 'open';
    }
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    if (widget.task == null) {
      final resp = await ParseService.createTask(
        _title.text.trim(),
        _desc.text.trim(),
        status: _status,
      );
      setState(() => _loading = false);
      if (resp.success) {
        print('TASK CREATED success');
        if (!mounted) return;
        Navigator.of(context).pop(true);
      } else {
        final msg = resp.error?.message ?? 'Create failed';
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    } else {
      final id = widget.task!.objectId!;
      final resp = await ParseService.updateTask(
        id,
        _title.text.trim(),
        _desc.text.trim(),
        _status == 'completed',
        status: _status,
      );
      setState(() => _loading = false);
      if (resp.success) {
        if (!mounted) return;
        Navigator.of(context).pop(true);
      } else {
        final msg = resp.error?.message ?? 'Update failed';
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Task' : 'New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Enter title' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _desc,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 4,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Status:'),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: _status,
                      items: _statuses
                          .map(
                            (s) => DropdownMenuItem(
                              value: s,
                              child: Text(s.toUpperCase()),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _status = v ?? 'open'),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _save,
                    child: _loading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isEdit ? 'Update' : 'Create'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
