import 'package:flutter/material.dart';
import '../services/parse_service.dart';
import 'task_form_screen.dart';
import 'login_screen.dart';
import '../widgets/task_tile.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'completed_tasks_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _loading = true;
  List<ParseObject> _tasks = [];
  String _currentFilterTitle = 'All Tasks';
  String? _currentStatusFilter;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks({String? status, String? title}) async {
    setState(() {
      _loading = true;
      _currentStatusFilter = status;
      _currentFilterTitle = title ??
          (status == null
              ? 'All Tasks'
              : '${status[0].toUpperCase()}${status.substring(1)} Tasks');
    });

    final tasks = await ParseService.getTasks(status: status);

    // If session invalid, ParseService.getTasks clears local user -> detect and re-route to login.
    final current = await ParseUser.currentUser() as ParseUser?;
    if (current == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session expired — please log in again.')),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
      return;
    }

    setState(() {
      _tasks = tasks;
      _loading = false;
    });
  }

  Future<void> _handleLogout() async {
    final success = await ParseService.logout();
    if (success) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout failed. Try again or check network.'),
        ),
      );
    }
  }

  void _openCreate() async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const TaskFormScreen()));
    if (result == true) await _loadTasks(status: _currentStatusFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentFilterTitle),
        actions: [
          IconButton(
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.indigo),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Task Manager',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(height: 6),
                  Text('Folders', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('All Tasks'),
              onTap: () {
                Navigator.of(context).pop();
                _loadTasks(status: null, title: 'All Tasks');
              },
            ),
            ListTile(
              leading: const Icon(Icons.inbox),
              title: const Text('Open'),
              onTap: () {
                Navigator.of(context).pop();
                _loadTasks(status: 'open', title: 'Open Tasks');
              },
            ),
            ListTile(
              leading: const Icon(Icons.pending_actions),
              title: const Text('Pending'),
              onTap: () {
                Navigator.of(context).pop();
                _loadTasks(status: 'pending', title: 'Pending Tasks');
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Completed Tasks'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CompletedTasksScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadTasks(status: _currentStatusFilter),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _tasks.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 120),
                      Center(child: Text('No tasks yet. Tap + to add.')),
                    ],
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (c, i) {
                      final item = _tasks[i];
                      return TaskTile(
                        task: item,
                        onChanged: () async =>
                            await _loadTasks(status: _currentStatusFilter),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreate,
        child: const Icon(Icons.add),
      ),
    );
  }
}
