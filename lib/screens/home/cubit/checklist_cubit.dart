import 'dart:async';

import 'package:checklist_app/app/core/utils/checklist_filter_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:checklist_app/app/core/utils/errors/failures.dart';
import 'package:checklist_app/data/models/checklist_item_model.dart';
import 'package:checklist_app/data/repo/checklist_repo.dart';
import 'package:checklist_app/screens/home/cubit/checklist_state.dart';

class ChecklistCubit extends Cubit<ChecklistState> {
  final ChecklistRepository _repository;
  final Uuid _uuid = const Uuid();
  StreamSubscription<List<ChecklistItemModel>>? _itemsSubscription;

  ChecklistCubit(this._repository) : super(const ChecklistState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _repository.init();
      _subscribeToItems();
      await loadItems();
    } catch (e) {
      emit(
        state.copyWith(
          status: ChecklistStatus.failure,
          errorMessage: _extractErrorMessage(e),
        ),
      );
    }
  }

  void _subscribeToItems() {
    _itemsSubscription?.cancel();
    _itemsSubscription = _repository.watchAllItems().listen(
      (items) {
        _updateItems(items);
      },
      onError: (error) {
        emit(
          state.copyWith(
            status: ChecklistStatus.failure,
            errorMessage: _extractErrorMessage(error),
          ),
        );
      },
    );
  }

  Future<void> loadItems() async {
    try {
      emit(
        state.copyWith(
          status: ChecklistStatus.loading,
          clearErrorMessage: true,
        ),
      );

      final items = _repository.getAllItems();
      _updateItems(items);
    } catch (e) {
      emit(
        state.copyWith(
          status: ChecklistStatus.failure,
          errorMessage: _extractErrorMessage(e),
        ),
      );
    }
  }

  Future<void> addItem({
    required String title,
    required String description,
    required Priority priority,
    DateTime? dueDate,
  }) async {
    try {
      final now = DateTime.now();
      final newItem = ChecklistItemModel(
        id: _uuid.v4(),
        title: title.trim(),
        description: description.trim(),
        isCompleted: false,
        priority: priority,
        createdAt: now,
        updatedAt: now,
        dueDate: dueDate,
      );

      await _repository.addItem(newItem);
    } catch (e) {
      if (e is! ValidationFailure) {
        emit(
          state.copyWith(
            status: ChecklistStatus.failure,
            errorMessage: _extractErrorMessage(e),
          ),
        );
      }
      rethrow;
    }
  }

  Future<void> updateItem(ChecklistItemModel item) async {
    try {
      final updatedItem = item.copyWith(updatedAt: DateTime.now());
      await _repository.updateItem(updatedItem);
    } catch (e) {
      if (e is! ValidationFailure) {
        emit(
          state.copyWith(
            status: ChecklistStatus.failure,
            errorMessage: _extractErrorMessage(e),
          ),
        );
      }
      rethrow;
    }
  }

  Future<void> toggleCompletion(ChecklistItemModel item) async {
    try {
      final now = DateTime.now();
      final updatedItem = item.copyWith(
        isCompleted: !item.isCompleted,
        completedAt: !item.isCompleted ? now : null,
        updatedAt: now,
      );

      await _repository.updateItem(updatedItem);
    } catch (e) {
      emit(
        state.copyWith(
          status: ChecklistStatus.failure,
          errorMessage: _extractErrorMessage(e),
        ),
      );
      rethrow;
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await _repository.deleteItem(id);
    } catch (e) {
      emit(
        state.copyWith(
          status: ChecklistStatus.failure,
          errorMessage: _extractErrorMessage(e),
        ),
      );
      rethrow;
    }
  }

  Future<void> deleteAllItems() async {
    try {
      await _repository.deleteAll();
    } catch (e) {
      emit(
        state.copyWith(
          status: ChecklistStatus.failure,
          errorMessage: _extractErrorMessage(e),
        ),
      );
      rethrow;
    }
  }

  Future<void> deleteCompletedItems() async {
    try {
      final completed = ChecklistRepositoryImpl.applyFilter(
        state.items,
        const ChecklistFilter(showCompleted: true),
      );
      for (final item in completed) {
        await _repository.deleteItem(item.id);
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ChecklistStatus.failure,
          errorMessage: _extractErrorMessage(e),
        ),
      );
      rethrow;
    }
  }

  void changeSortType(ChecklistSortType sortType) {
    if (sortType == state.sortType) return;

    emit(state.copyWith(sortType: sortType));
    _refreshFilteredItems();
  }

  void filterByCompletion({
    required bool showCompleted,
    required bool showIncomplete,
  }) {
    emit(
      state.copyWith(
        showCompletedOnly: showCompleted,
        showIncompleteOnly: showIncomplete,
      ),
    );
    _refreshFilteredItems();
  }

  void filterByPriority(Priority? priority) {
    emit(
      state.copyWith(
        filterByPriority: priority,
        clearPriorityFilter: priority == null,
      ),
    );
    _refreshFilteredItems();
  }

  void clearFilters() {
    emit(
      state.copyWith(
        showCompletedOnly: false,
        showIncompleteOnly: false,
        filterByPriority: null,
        clearPriorityFilter: true,
      ),
    );
    _refreshFilteredItems();
  }

  Map<String, int> getStatistics() {
    try {
      return _repository.getStatistics();
    } catch (e) {
      return {
        'total': 0,
        'completed': 0,
        'incomplete': 0,
        'low': 0,
        'medium': 0,
        'high': 0,
        'urgent': 0,
      };
    }
  }

  int getCompletionRate() {
    final stats = getStatistics();
    final total = stats['total'] ?? 0;
    if (total == 0) return 0;
    final completed = stats['completed'] ?? 0;
    return ((completed / total) * 100).round();
  }

  void _updateItems(List<ChecklistItemModel> items) {
    final filter = _buildFilter();
    final filteredItems = ChecklistRepositoryImpl.applyFilter(items, filter);
    emit(
      state.copyWith(
        status: ChecklistStatus.success,
        items: items,
        filteredItems: filteredItems,
        clearErrorMessage: true,
      ),
    );
  }

  void _refreshFilteredItems() {
    if (state.items.isEmpty) return;

    final filter = _buildFilter();
    final filteredItems = ChecklistRepositoryImpl.applyFilter(
      state.items,
      filter,
    );
    emit(state.copyWith(filteredItems: filteredItems));
  }

  ChecklistFilter _buildFilter() {
    return ChecklistFilter(
      showCompleted: state.showCompletedOnly,
      showIncomplete: state.showIncompleteOnly,
      priority: state.filterByPriority,
      sortType: _mapSortType(state.sortType),
      sortAscending: _isSortAscending(state.sortType),
    );
  }

  ChecklistSortType? _mapSortType(ChecklistSortType sortType) {
    switch (sortType) {
      case ChecklistSortType.priority:
        return ChecklistSortType.priority;
      case ChecklistSortType.dateNew:
        return ChecklistSortType.dateNew;
      case ChecklistSortType.dateOld:
        return ChecklistSortType.dateOld;
      case ChecklistSortType.name:
        return ChecklistSortType.name;
    }
  }

  bool _isSortAscending(ChecklistSortType sortType) {
    return sortType == ChecklistSortType.dateOld;
  }

  String _extractErrorMessage(dynamic error) {
    if (error is Failure) {
      return error.message;
    }
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'An unexpected error occurred: ${error.toString()}';
  }

  @override
  Future<void> close() {
    _itemsSubscription?.cancel();
    return super.close();
  }
}
