import 'package:checklist_app/app/core/constants/hive_constants.dart';
import 'package:checklist_app/app/core/utils/checklist_filter_util.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:checklist_app/app/core/utils/errors/failures.dart';
import 'package:checklist_app/data/models/checklist_item_model.dart';

abstract class ChecklistRepository {
  Future<void> init();
  Future<void> close();

  Future<void> addItem(ChecklistItemModel item);
  Future<void> updateItem(ChecklistItemModel item);
  Future<void> deleteItem(String id);
  Future<void> deleteAll();

  ChecklistItemModel? getItem(String id);
  List<ChecklistItemModel> getAllItems();
  List<ChecklistItemModel> getItems(ChecklistFilter filter);
  Stream<List<ChecklistItemModel>> watchAllItems();

  Map<String, int> getStatistics();
}

class ChecklistRepositoryImpl implements ChecklistRepository {
  static bool _adaptersRegistered = false;
  bool _isInitialized = false;

  Box<ChecklistItemModel>? _box;

  static List<ChecklistItemModel> applyFilter(
    List<ChecklistItemModel> items,
    ChecklistFilter filter,
  ) {
    var filtered = List<ChecklistItemModel>.from(items);

    if (filter.showCompleted && !filter.showIncomplete) {
      filtered = filtered.where((item) => item.isCompleted).toList();
    } else if (filter.showIncomplete && !filter.showCompleted) {
      filtered = filtered.where((item) => !item.isCompleted).toList();
    }

    if (filter.priority != null) {
      filtered = filtered
          .where((item) => item.priority == filter.priority)
          .toList();
    }

    if (filter.sortType != null) {
      switch (filter.sortType!) {
        case ChecklistSortType.priority:
          filtered.sort(
            (a, b) => filter.sortAscending
                ? a.priority.value.compareTo(b.priority.value)
                : b.priority.value.compareTo(a.priority.value),
          );
          break;
        case ChecklistSortType.dateNew:
          filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case ChecklistSortType.dateOld:
          filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          break;
        case ChecklistSortType.name:
          filtered.sort(
            (a, b) => filter.sortAscending
                ? a.title.toLowerCase().compareTo(b.title.toLowerCase())
                : b.title.toLowerCase().compareTo(a.title.toLowerCase()),
          );
          break;
      }
    }

    return filtered;
  }

  @override
  Future<void> init() async {
    try {
      if (!Hive.isAdapterRegistered(0)) {
        await Hive.initFlutter();
      }

      if (!_adaptersRegistered) {
        if (!Hive.isAdapterRegistered(0)) {
          Hive.registerAdapter(ChecklistItemModelAdapter());
        }
        if (!Hive.isAdapterRegistered(1)) {
          Hive.registerAdapter(PriorityAdapter());
        }
        _adaptersRegistered = true;
      }

      _box = await Hive.openBox<ChecklistItemModel>(
        HiveConstants.checklistBoxName,
      );
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      throw CacheFailure('Failed to initialize repository: ${e.toString()}');
    }
  }

  Box<ChecklistItemModel> get _boxInstance {
    if (!_isInitialized || _box == null || !_box!.isOpen) {
      throw CacheFailure('Repository not initialized. Call init() first.');
    }
    return _box!;
  }

  @override
  Future<void> addItem(ChecklistItemModel item) async {
    try {
      _validateItem(item);
      await _boxInstance.put(item.id, item);
    } catch (e) {
      if (e is Failure) rethrow;
      throw CacheFailure('Failed to add item: ${e.toString()}');
    }
  }

  @override
  List<ChecklistItemModel> getAllItems() {
    try {
      return _boxInstance.values.toList();
    } catch (e) {
      if (e is Failure) rethrow;
      throw CacheFailure('Failed to get items: ${e.toString()}');
    }
  }

  @override
  ChecklistItemModel? getItem(String id) {
    try {
      if (id.isEmpty) {
        throw ValidationFailure('Item ID cannot be empty');
      }
      return _boxInstance.get(id);
    } catch (e) {
      if (e is Failure) rethrow;
      throw CacheFailure('Failed to get item: ${e.toString()}');
    }
  }

  @override
  Future<void> updateItem(ChecklistItemModel item) async {
    try {
      _validateItem(item);
      final existingItem = _boxInstance.get(item.id);
      if (existingItem == null) {
        throw NotFoundFailure('Item with id ${item.id} not found');
      }
      await _boxInstance.put(item.id, item);
    } catch (e) {
      if (e is Failure) rethrow;
      throw CacheFailure('Failed to update item: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    try {
      if (id.isEmpty) {
        throw ValidationFailure('Item ID cannot be empty');
      }
      final item = _boxInstance.get(id);
      if (item == null) {
        throw NotFoundFailure('Item with id $id not found');
      }
      await _boxInstance.delete(id);
    } catch (e) {
      if (e is Failure) rethrow;
      throw CacheFailure('Failed to delete item: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAll() async {
    try {
      await _boxInstance.clear();
    } catch (e) {
      if (e is Failure) rethrow;
      throw CacheFailure('Failed to delete all items: ${e.toString()}');
    }
  }

  @override
  List<ChecklistItemModel> getItems(ChecklistFilter filter) {
    try {
      final items = getAllItems();
      return ChecklistRepositoryImpl.applyFilter(items, filter);
    } catch (e) {
      if (e is Failure) rethrow;
      throw CacheFailure('Failed to get filtered items: ${e.toString()}');
    }
  }

  @override
  Map<String, int> getStatistics() {
    try {
      final items = getAllItems();
      return {
        'total': items.length,
        'completed': items.where((item) => item.isCompleted).length,
        'incomplete': items.where((item) => !item.isCompleted).length,
        'low': items.where((item) => item.priority == Priority.low).length,
        'medium': items
            .where((item) => item.priority == Priority.medium)
            .length,
        'high': items.where((item) => item.priority == Priority.high).length,
        'urgent': items
            .where((item) => item.priority == Priority.urgent)
            .length,
      };
    } catch (e) {
      if (e is Failure) rethrow;
      throw CacheFailure('Failed to get statistics: ${e.toString()}');
    }
  }

  @override
  Stream<List<ChecklistItemModel>> watchAllItems() {
    try {
      return _boxInstance.watch().map((_) => getAllItems());
    } catch (e) {
      if (e is Failure) rethrow;
      throw CacheFailure('Failed to watch items: ${e.toString()}');
    }
  }

  @override
  Future<void> close() async {
    try {
      if (_box != null && _box!.isOpen) {
        await _box!.close();
      }
      _isInitialized = false;
    } catch (e) {
      throw CacheFailure('Failed to close repository: ${e.toString()}');
    }
  }

  void _validateItem(ChecklistItemModel item) {
    if (item.id.isEmpty) {
      throw const ValidationFailure('Item ID cannot be empty');
    }
    if (item.title.trim().isEmpty) {
      throw const ValidationFailure('Item title cannot be empty');
    }
    if (item.title.trim().length > 200) {
      throw const ValidationFailure('Title cannot exceed 200 characters');
    }
    // Description is optional, but if provided, it should not exceed max length
    if (item.description.trim().isNotEmpty &&
        item.description.trim().length > 1000) {
      throw const ValidationFailure(
        'Description cannot exceed 1000 characters',
      );
    }
  }
}
