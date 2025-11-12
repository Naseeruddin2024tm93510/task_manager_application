import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../widgets/task_tile.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});
  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  bool _loading = true;
  List<ParseObject> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadCompleted();
  }

  Future<void> _loadCompleted() async {
    setState(() => _loading = true);
    final user = await ParseUser.currentUser();
    if (user == null) {
      if (!mounted) return;
      Navigator.of(context).pop();
      return;
    }
    final query = QueryBuilder<ParseObject>(ParseObject('Task'))
      ..whereEqualTo('owner', ParseObject('_User')..objectId = user.objectId)
      ..whereEqualTo('status', 'completed')
      ..orderByDescending('completedAt');
    final resp = await query.query();
    List<ParseObject> results = <ParseObject>[];
    if (resp.success && resp.results != null) {
      results = resp.results as List<ParseObject>;
    }
    setState(() {
      _tasks = results;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Completed Tasks')),
      body: RefreshIndicator(
        onRefresh: _loadCompleted,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _tasks.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 120),
                      Center(child: Text('No completed tasks yet.')),
                    ],
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (c, i) =>
                        TaskTile(task: _tasks[i], onChanged: _loadCompleted),
                  ),
      ),
    );
  }
}
