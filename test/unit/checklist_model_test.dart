import 'package:flutter_test/flutter_test.dart';
import 'package:checklist_app/data/models/checklist_item_model.dart';

void main() {
  group('ChecklistItemModel', () {
    test('creates instance with required fields', () {
      final now = DateTime.now();
      final item = ChecklistItemModel(
        id: '1',
        title: 'Test Item',
        description: 'Test Description',
        isCompleted: false,
        priority: Priority.medium,
        createdAt: now,
      );

      expect(item.id, '1');
      expect(item.title, 'Test Item');
      expect(item.description, 'Test Description');
      expect(item.isCompleted, false);
      expect(item.priority, Priority.medium);
      expect(item.createdAt, now);
      expect(item.completedAt, null);
      expect(item.dueDate, null);
    });

    test('copyWith updates select fields and preserves others', () {
      final now = DateTime.now();
      final original = ChecklistItemModel(
        id: '1',
        title: 'Original',
        description: 'Desc',
        isCompleted: false,
        priority: Priority.low,
        createdAt: now,
      );

      final updated = original.copyWith(
        title: 'Updated',
        isCompleted: true,
        priority: Priority.high,
      );

      expect(updated.id, original.id);
      expect(updated.title, 'Updated');
      expect(updated.description, original.description);
      expect(updated.isCompleted, true);
      expect(updated.priority, Priority.high);
      expect(updated.createdAt, original.createdAt);
    });
  });
}
