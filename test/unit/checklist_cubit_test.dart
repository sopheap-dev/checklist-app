import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:checklist_app/data/models/checklist_item_model.dart';
import 'package:checklist_app/data/repo/checklist_repo.dart';
import 'package:checklist_app/screens/home/cubit/checklist_cubit.dart';
import 'package:checklist_app/screens/home/cubit/checklist_state.dart';
import 'package:checklist_app/app/core/constants/hive_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late ChecklistRepository repository;
  late ChecklistCubit cubit;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_cubit_test_');
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
    cubit = ChecklistCubit(repository);
    await Future.delayed(const Duration(milliseconds: 50));
  });

  tearDown(() async {
    await cubit.close();
    await repository.close();
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('initial state becomes success and empty after initialize', () async {
    expect(cubit.state.isSuccess, true);
    expect(cubit.state.items, isEmpty);
    expect(cubit.state.filteredItems, isEmpty);
  });

  blocTest<ChecklistCubit, ChecklistState>(
    'addItem inserts item and reflects in state (via stream)',
    build: () => cubit,
    act: (c) async {
      await c.addItem(
        title: 'Test',
        description: 'Desc',
        priority: Priority.high,
      );
      await Future.delayed(const Duration(milliseconds: 50));
    },
    verify: (c) {
      expect(c.state.isSuccess, true);
      expect(c.state.items.length, 1);
      expect(c.state.items.first.title, 'Test');
    },
  );

  blocTest<ChecklistCubit, ChecklistState>(
    'toggleCompletion sets completed and timestamp',
    build: () => cubit,
    act: (c) async {
      await c.addItem(
        title: 'Toggle',
        description: 'Desc',
        priority: Priority.medium,
      );
      await Future.delayed(const Duration(milliseconds: 30));
      final item = c.state.items.first;
      await c.toggleCompletion(item);
      await Future.delayed(const Duration(milliseconds: 30));
    },
    verify: (c) {
      final updated = c.state.items.first;
      expect(updated.isCompleted, true);
      expect(updated.completedAt, isNotNull);
    },
  );

  blocTest<ChecklistCubit, ChecklistState>(
    'deleteItem removes item',
    build: () => cubit,
    act: (c) async {
      await c.addItem(
        title: 'Delete',
        description: 'Desc',
        priority: Priority.low,
      );
      await Future.delayed(const Duration(milliseconds: 30));
      final id = c.state.items.first.id;
      await c.deleteItem(id);
      await Future.delayed(const Duration(milliseconds: 30));
    },
    verify: (c) {
      expect(c.state.items, isEmpty);
      expect(c.state.filteredItems, isEmpty);
    },
  );
}
