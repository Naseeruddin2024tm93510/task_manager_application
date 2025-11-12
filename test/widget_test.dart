// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A tiny local counter widget for tests (independent from your app).
class _TestCounterApp extends StatefulWidget {
  const _TestCounterApp({Key? key}) : super(key: key);
  @override
  State<_TestCounterApp> createState() => _TestCounterAppState();
}

class _TestCounterAppState extends State<_TestCounterApp> {
  int _count = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Counter Test')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() => _count++),
          child: const Icon(Icons.add),
        ),
        body: Center(child: Text('$_count', key: const Key('counter'))),
      ),
    );
  }
}

void main() {
  testWidgets('Counter increments smoke test (local)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const _TestCounterApp());

    // initial state should show 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // tap the FAB
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // now it should show 1
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
