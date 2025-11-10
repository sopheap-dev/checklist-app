import 'package:checklist_app/data/models/checklist_item_model.dart';

enum ChecklistSortType { priority, dateNew, dateOld, name }

class ChecklistFilter {
  final bool showCompleted;
  final bool showIncomplete;
  final Priority? priority;
  final ChecklistSortType? sortType;
  final bool sortAscending;

  const ChecklistFilter({
    this.showCompleted = false,
    this.showIncomplete = false,
    this.priority,
    this.sortType,
    this.sortAscending = false,
  });
}
