import 'package:checklist_app/app/core/utils/checklist_filter_util.dart';
import 'package:equatable/equatable.dart';
import 'package:checklist_app/data/models/checklist_item_model.dart';

enum ChecklistStatus { initial, loading, success, failure }

class ChecklistState extends Equatable {
  final ChecklistStatus status;
  final List<ChecklistItemModel> items;
  final List<ChecklistItemModel> filteredItems;
  final ChecklistSortType sortType;
  final bool showCompletedOnly;
  final bool showIncompleteOnly;
  final Priority? filterByPriority;
  final String? errorMessage;

  const ChecklistState({
    this.status = ChecklistStatus.initial,
    this.items = const [],
    this.filteredItems = const [],
    this.sortType = ChecklistSortType.priority,
    this.showCompletedOnly = false,
    this.showIncompleteOnly = false,
    this.filterByPriority,
    this.errorMessage,
  });

  ChecklistState copyWith({
    ChecklistStatus? status,
    List<ChecklistItemModel>? items,
    List<ChecklistItemModel>? filteredItems,
    ChecklistSortType? sortType,
    bool? showCompletedOnly,
    bool? showIncompleteOnly,
    Priority? filterByPriority,
    String? errorMessage,
    bool clearPriorityFilter = false,
    bool clearErrorMessage = false,
  }) {
    return ChecklistState(
      status: status ?? this.status,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      sortType: sortType ?? this.sortType,
      showCompletedOnly: showCompletedOnly ?? this.showCompletedOnly,
      showIncompleteOnly: showIncompleteOnly ?? this.showIncompleteOnly,
      filterByPriority: clearPriorityFilter
          ? null
          : (filterByPriority ?? this.filterByPriority),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  bool get hasActiveFilters =>
      showCompletedOnly || showIncompleteOnly || filterByPriority != null;

  bool get hasItems => items.isNotEmpty;

  bool get hasFilteredItems => filteredItems.isNotEmpty;

  int get totalCount => items.length;

  int get completedCount => items.where((item) => item.isCompleted).length;

  int get incompleteCount => items.where((item) => !item.isCompleted).length;

  bool get isLoading => status == ChecklistStatus.loading;

  bool get isSuccess => status == ChecklistStatus.success;

  bool get isFailure => status == ChecklistStatus.failure;

  @override
  List<Object?> get props => [
    status,
    items,
    filteredItems,
    sortType,
    showCompletedOnly,
    showIncompleteOnly,
    filterByPriority,
    errorMessage,
  ];
}
