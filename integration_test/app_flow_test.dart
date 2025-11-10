import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:checklist_app/app/app.dart';
import 'package:checklist_app/app/config/di/di.dart';

Future<void> _waitForFinder(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 3),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  fail('Timed out waiting for $finder');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Splash → Home → Add item → Dashboard stats reflect data', (
    tester,
  ) async {
    await setupDependencies();
    await tester.pumpWidget(const CheckListApp());

    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    expect(find.text('Add Item'), findsOneWidget);

    await tester.tap(find.text('Add Item'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title *'),
      'Task A',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Description'),
      'My first task',
    );

    final submitButton = find.byKey(const Key('addEditSubmitButton'));
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton, warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 200));

    await _waitForFinder(tester, find.text('Task A'));

    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Completion Status'), findsOneWidget);
    expect(find.textContaining('Priority Distribution'), findsOneWidget);
  });
}
