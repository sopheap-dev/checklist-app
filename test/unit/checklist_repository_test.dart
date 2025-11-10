import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:checklist_app/data/models/checklist_item_model.dart';
import 'package:checklist_app/data/repo/checklist_repo.dart';
import 'package:checklist_app/app/core/constants/hive_constants.dart';

void main() {
  late Directory tempDir;
  late ChecklistRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_repo_test_');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(HiveConstants.checklistItemTypeId)) {
      Hive.registerAdapter(ChecklistItemModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveConstants.priorityTypeId)) {
      Hive.registerAdapter(PriorityAdapter());
    }

    await Hive.openBox<ChecklistItemModel>(HiveConstants.checklistBoxName);
    repository = ChecklistRepositoryImpl();
    await repository.init();
    await repository.deleteAll();
  });

  tearDown(() async {
    await repository.close();
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('add/get/update/delete and statistics work', () async {
    final now = DateTime(2024, 1, 1);
    final item1 = ChecklistItemModel(
      id: '1',
      title: 'Item 1',
      description: 'Desc 1',
      isCompleted: false,
      priority: Priority.medium,
      createdAt: now,
    );
    final item2 = ChecklistItemModel(
      id: '2',
      title: 'Item 2',
      description: 'Desc 2',
      isCompleted: true,
      priority: Priority.high,
      createdAt: now.add(const Duration(days: 1)),
      completedAt: now.add(const Duration(days: 2)),
    );

    await repository.addItem(item1);
    await repository.addItem(item2);

    final all = repository.getAllItems();
    expect(all.length, 2);

    final fetched = repository.getItem('1');
    expect(fetched?.title, 'Item 1');

    await repository.updateItem(item1.copyWith(title: 'Updated 1'));
    expect(repository.getItem('1')?.title, 'Updated 1');

    final stats = repository.getStatistics();
    expect(stats['total'], 2);
    expect(stats['completed'], 1);
    expect(stats['incomplete'], 1);
    expect(stats['high'], 1);
    expect(stats['medium'], 1);

    await repository.deleteItem('1');
    expect(repository.getItem('1'), isNull);

    await repository.deleteAll();
    expect(repository.getAllItems(), isEmpty);
  });
}
