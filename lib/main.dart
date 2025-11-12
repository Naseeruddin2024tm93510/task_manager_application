import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/tasks_screen.dart';

const String APP_ID = 'epcfqPQfqUfLoeykRU2917LX01J6VjponmjAmO2o';
const String CLIENT_KEY = 'vgcDzeBYfs6ZFNpPofnvy9fM5iPhqTicuDryLdr7';
const String PARSE_SERVER_URL = 'https://parseapi.back4app.com';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    APP_ID,
    PARSE_SERVER_URL,
    clientKey: CLIENT_KEY,
    autoSendSessionId: true,
    debug: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const EntryDecider(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class EntryDecider extends StatefulWidget {
  const EntryDecider({super.key});
  @override
  State<EntryDecider> createState() => _EntryDeciderState();
}

class _EntryDeciderState extends State<EntryDecider> {
  bool _loading = true;
  bool _hasUser = false;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    final current = await ParseUser.currentUser() as ParseUser?;
    setState(() {
      _hasUser = current != null && current.sessionToken != null;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _hasUser ? const TasksScreen() : const LoginScreen();
  }
}
