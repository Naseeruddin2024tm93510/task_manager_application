import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ParseService {
  // Register with email & password
  static Future<ParseResponse> signUp(String email, String password) async {
    final user = ParseUser.createUser(email, password, email);
    final resp = await user.signUp();
    try {
      final cur = await ParseUser.currentUser() as ParseUser?;
      print(
        'SIGNUP debug -> resp.success=${resp.success}, currentUser=${cur?.username}, sessionToken=${cur?.sessionToken}',
      );
    } catch (e) {
      print('SIGNUP debug -> error reading current user after signup: $e');
    }
    return resp;
  }

  // Login (returns ParseResponse)
  static Future<ParseResponse> login(String email, String password) async {
    final user = ParseUser(email, password, null);
    final resp = await user.login();
    try {
      final cur = await ParseUser.currentUser() as ParseUser?;
      print(
        'LOGIN debug -> resp.success=${resp.success}, currentUser=${cur?.username}, sessionToken=${cur?.sessionToken}',
      );
    } catch (e) {
      print('LOGIN debug -> error reading current user after login: $e');
    }
    return resp;
  }

  // Return the current ParseUser (or null)
  static Future<ParseUser?> currentUser() async {
    return await ParseUser.currentUser() as ParseUser?;
  }

  // Logout helper
  static Future<bool> logout() async {
    try {
      final current = await ParseUser.currentUser() as ParseUser?;
      print(
        'LOGOUT debug -> current user: ${current?.username}, sessionToken: ${current?.sessionToken}',
      );
      if (current == null) {
        print('LOGOUT debug -> no current user found, treating as logged out.');
        return true;
      }
      final ParseResponse resp = await current.logout();
      if (resp.success) {
        print('LOGOUT debug -> logout success.');
        return true;
      } else {
        final code = resp.error?.code;
        final msg = resp.error?.message;
        print('LOGOUT debug -> logout failed. code=$code msg=$msg');
        if (code == 209 ||
            (msg != null && msg.toLowerCase().contains('invalid session'))) {
          print(
            'LOGOUT debug -> Invalid session token detected — clearing local session and proceeding as logged out.',
          );
          try {
            await current.logout();
          } catch (e) {
            print('LOGOUT debug -> second logout attempt error: $e');
          }
          return true;
        }
        return false;
      }
    } catch (e, st) {
      print('LOGOUT debug -> exception during logout: $e\n$st');
      try {
        final cur = await ParseUser.currentUser() as ParseUser?;
        if (cur != null) {
          try {
            await cur.logout();
          } catch (_) {}
        }
      } catch (_) {}
      return true;
    }
  }

  // Create Task
  static Future<ParseResponse> createTask(
    String title,
    String description, {
    String status = 'open',
  }) async {
    final current = await ParseUser.currentUser() as ParseUser?;
    print(
      'CREATE_TASK debug -> current user: ${current?.username}, objectId: ${current?.objectId}, sessionToken: ${current?.sessionToken}',
    );

    final task = ParseObject('Task')
      ..set('title', title)
      ..set('description', description)
      ..set('done', status == 'completed')
      ..set('status', status);

    if (current != null && current.objectId != null) {
      final ownerPointer = ParseObject('_User')..objectId = current.objectId;
      task.set('owner', ownerPointer);
    }

    if (status == 'completed') {
      task.set('completedAt', DateTime.now());
    }

    final resp = await task.save();
    print(
      'CREATE_TASK debug -> resp.success=${resp.success}, error=${resp.error?.message}, objectId=${resp.results?.firstOrNull}',
    );
    return resp;
  }

  // Read Tasks (owned by current user)
  // Handles invalid session tokens (clears local session and returns empty list)
  static Future<List<ParseObject>> getTasks({String? status}) async {
    try {
      final user = await ParseUser.currentUser() as ParseUser?;
      if (user == null || user.objectId == null) {
        print('GET_TASKS debug -> no current user, returning empty list.');
        return <ParseObject>[];
      }

      final ownerPointer = ParseObject('_User')..objectId = user.objectId;
      final query = QueryBuilder<ParseObject>(ParseObject('Task'))
        ..whereEqualTo('owner', ownerPointer)
        ..orderByDescending('createdAt');

      if (status != null && status.isNotEmpty) {
        query.whereEqualTo('status', status);
      }

      final response = await query.query();

      if (response.success && response.results != null) {
        print(
          'GET_TASKS debug -> got ${response.results!.length} tasks for status=$status',
        );
        return response.results as List<ParseObject>;
      } else {
        final code = response.error?.code;
        final msg = response.error?.message;
        print('GET_TASKS debug -> query failed. code=$code msg=$msg');

        if (code == 209 ||
            (msg != null && msg.toLowerCase().contains('invalid session'))) {
          print(
            'GET_TASKS debug -> Invalid session token detected. Attempting to clear local session.',
          );
          try {
            final cur = await ParseUser.currentUser() as ParseUser?;
            if (cur != null) {
              await cur.logout();
            }
          } catch (e) {
            print('GET_TASKS debug -> error while clearing session: $e');
          }
          return <ParseObject>[];
        }
      }
    } catch (e, st) {
      print('GET_TASKS debug -> unexpected exception: $e\n$st');
    }
    return <ParseObject>[];
  }

  // Update task
  static Future<ParseResponse> updateTask(
    String objectId,
    String title,
    String description,
    bool done, {
    String? status,
  }) async {
    final task = ParseObject('Task')..objectId = objectId;
    task.set('title', title);
    task.set('description', description);
    task.set('done', done);

    if (status != null && status.isNotEmpty) {
      task.set('status', status);
      if (status == 'completed') {
        task.set('completedAt', DateTime.now());
      } else {
        task.unset('completedAt');
      }
    }

    final resp = await task.save();
    print(
      'UPDATE_TASK debug -> objectId=$objectId success=${resp.success} error=${resp.error?.message}',
    );
    return resp;
  }

  // Delete task
  static Future<ParseResponse> deleteTask(String objectId) async {
    final task = ParseObject('Task')..objectId = objectId;
    final resp = await task.delete();
    print(
      'DELETE_TASK debug -> objectId=$objectId success=${resp.success} error=${resp.error?.message}',
    );
    return resp;
  }
}
