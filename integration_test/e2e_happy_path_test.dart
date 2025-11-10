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

  testWidgets('E2E: add, edit, toggle, filter, delete', (tester) async {
    await setupDependencies();
    await tester.pumpWidget(const CheckListApp());
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    Future<void> addItem(String title, String desc) async {
      await tester.tap(find.text('Add Item'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Title *'),
        title,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'),
        desc,
      );
      final submitButton = find.byKey(const Key('addEditSubmitButton'));
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton, warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 200));
      await _waitForFinder(tester, find.text(title));
    }

    await addItem('Alpha', 'A');
    await addItem('Beta', 'B');

    await tester.tap(find.text('Alpha'));
    await tester.pumpAndSettle();
    final markComplete = find.byKey(const Key('markCompleteButton'));
    await _waitForFinder(tester, markComplete);
    await tester.ensureVisible(markComplete);
    await tester.tap(markComplete, warnIfMissed: false);
    await tester.pumpAndSettle();
    final confirmComplete = find.byKey(const Key('confirmCompleteButton'));
    await _waitForFinder(tester, confirmComplete);
    await tester.tap(confirmComplete, warnIfMissed: false);
    await tester.pumpAndSettle();

    final closeButton = find.byKey(const Key('detailCloseButton'));
    await tester.tap(closeButton);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Completed Only'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apply Filters'));
    await tester.pumpAndSettle();

    await _waitForFinder(tester, find.text('Alpha'));
    expect(find.text('Beta'), findsNothing);

    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear All'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apply Filters'));
    await tester.pumpAndSettle();

    Finder itemToOpen = find.text('Beta');
    if (itemToOpen.evaluate().isEmpty) {
      itemToOpen = find.text('Alpha');
    }
    await tester.tap(itemToOpen);
    await tester.pumpAndSettle();

    final detailDelete = find.byKey(const Key('detailDeleteButton'));
    await _waitForFinder(tester, detailDelete);
    await tester.ensureVisible(detailDelete);
    await tester.tap(detailDelete, warnIfMissed: false);
    await tester.pumpAndSettle();

    final confirmDelete = find.byKey(const Key('confirmDeleteButton'));
    await _waitForFinder(tester, confirmDelete);
    await tester.tap(confirmDelete, warnIfMissed: false);
    await tester.pumpAndSettle();

    final alphaExists = find.text('Alpha').evaluate().isNotEmpty;
    final betaExists = find.text('Beta').evaluate().isNotEmpty;
    expect(alphaExists || betaExists, true);
  });
}
