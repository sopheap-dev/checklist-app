import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'checklist_item_model.g.dart';

@HiveType(typeId: 0)
class ChecklistItemModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final bool isCompleted;

  @HiveField(4)
  final Priority priority;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime? updatedAt;

  @HiveField(7)
  final DateTime? completedAt;

  @HiveField(8)
  final DateTime? dueDate;

  const ChecklistItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.priority,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
    this.dueDate,
  });

  ChecklistItemModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    Priority? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    DateTime? dueDate,
  }) {
    return ChecklistItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    isCompleted,
    priority,
    createdAt,
    updatedAt,
    completedAt,
    dueDate,
  ];
}

@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  low,

  @HiveField(1)
  medium,

  @HiveField(2)
  high,

  @HiveField(3)
  urgent,
}

extension PriorityExtension on Priority {
  String get displayName {
    switch (this) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
      case Priority.urgent:
        return 'Urgent';
    }
  }

  int get value {
    switch (this) {
      case Priority.low:
        return 1;
      case Priority.medium:
        return 2;
      case Priority.high:
        return 3;
      case Priority.urgent:
        return 4;
    }
  }
}
