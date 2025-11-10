import 'package:checklist_app/app/core/utils/priority_util.dart';
import 'package:checklist_app/screens/home/cubit/checklist_cubit.dart';
import 'package:checklist_app/screens/home/cubit/checklist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:checklist_app/data/models/checklist_item_model.dart';
import 'package:checklist_app/app/config/themes/app_colors.dart';
import 'package:checklist_app/app/core/extensions/context_extension.dart';

class ChecklistItemDetailDialog extends StatelessWidget {
  final ChecklistItemModel item;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const ChecklistItemDetailDialog({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChecklistCubit, ChecklistState>(
      builder: (context, state) {
        final currentItem = state.items.firstWhere(
          (i) => i.id == item.id,
          orElse: () => item,
        );

        return _buildDialog(context, currentItem);
      },
    );
  }

  Widget _buildDialog(BuildContext context, ChecklistItemModel item) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final priorityColor = PriorityUtils.getPriorityColor(item.priority);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      priorityColor.withValues(alpha: 0.2),
                      priorityColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: textTheme.headlineSmall?.copyWith(
                              decoration: item.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: item.isCompleted
                                  ? colorScheme.onSurfaceVariant
                                  : null,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: priorityColor.withAlpha(51),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: priorityColor,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  PriorityUtils.getPriorityIcon(item.priority),
                                  size: 16,
                                  color: priorityColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  item.priority.displayName,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: priorityColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    if (item.description.isNotEmpty) ...[
                      Text(
                        'Description',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outlineVariant,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          item.description,
                          style: textTheme.bodyLarge?.copyWith(
                            decoration: item.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: item.isCompleted
                                ? colorScheme.onSurfaceVariant
                                : null,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    Text(
                      'Information',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      icon: Icons.info_outline,
                      label: 'Status',
                      value: item.isCompleted ? 'Completed' : 'Pending',
                      valueColor: item.isCompleted
                          ? AppColors.green
                          : AppColors.orange,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      icon: Icons.access_time,
                      label: 'Created',
                      value: _formatFullDate(item.createdAt),
                    ),
                    const SizedBox(height: 12),
                    if (item.isCompleted && item.completedAt != null) ...[
                      _buildInfoRow(
                        context,
                        icon: Icons.check_circle,
                        label: 'Completed',
                        value: _formatFullDate(item.completedAt!),
                        valueColor: AppColors.green,
                      ),
                      const SizedBox(height: 12),
                    ],

                    if (item.dueDate != null) ...[
                      _buildDueDateInfo(context),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () =>
                            _showCompleteConfirmation(context, item),
                        icon: Icon(
                          item.isCompleted
                              ? Icons.restart_alt
                              : Icons.check_circle,
                          size: 20,
                        ),
                        label: Text(
                          item.isCompleted
                              ? 'Mark Incomplete'
                              : 'Mark Complete',
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: item.isCompleted
                              ? colorScheme.surfaceContainerHighest
                              : AppColors.success,
                          foregroundColor: item.isCompleted
                              ? colorScheme.onSurface
                              : AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () =>
                                _showDeleteConfirmation(context, item),
                            icon: const Icon(Icons.delete_outline, size: 20),
                            label: const Text('Delete'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.error,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                              onEdit();
                            },
                            icon: const Icon(Icons.edit, size: 20),
                            label: const Text('Edit'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: valueColor ?? colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildDueDateInfo(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final now = DateTime.now();
    final dueDate = item.dueDate!;
    final isOverdue = !item.isCompleted && dueDate.isBefore(now);
    final isDueToday =
        dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;

    final dueDateColor = isOverdue
        ? AppColors.red
        : isDueToday
        ? AppColors.orange
        : AppColors.blue;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: dueDateColor.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dueDateColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isOverdue
                ? Icons.warning_rounded
                : isDueToday
                ? Icons.today
                : Icons.event,
            size: 20,
            color: dueDateColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Due Date',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatFullDate(dueDate),
                  style: textTheme.bodyMedium?.copyWith(
                    color: dueDateColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isOverdue) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Overdue',
                    style: textTheme.bodySmall?.copyWith(
                      color: dueDateColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else if (isDueToday) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Due today',
                    style: textTheme.bodySmall?.copyWith(
                      color: dueDateColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final difference = today.difference(dateOnly).inDays;

    if (difference == 0) {
      return 'Today at ${DateFormat.jm().format(date)}';
    } else if (difference == 1) {
      return 'Yesterday at ${DateFormat.jm().format(date)}';
    } else if (difference == -1) {
      return 'Tomorrow at ${DateFormat.jm().format(date)}';
    } else if (difference.abs() < 7) {
      return '${DateFormat.EEEE().format(date)} at ${DateFormat.jm().format(date)}';
    } else {
      return DateFormat.yMMMd().add_jm().format(date);
    }
  }

  void _showCompleteConfirmation(
    BuildContext context,
    ChecklistItemModel itemToToggle,
  ) {
    if (itemToToggle.isCompleted) {
      onToggle();
      return;
    }

    showDialog(
      context: context,
      builder: (completeDialogContext) => AlertDialog(
        title: const Text('Mark as Complete?'),
        content: Text('Mark "${itemToToggle.title}" as completed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(completeDialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(completeDialogContext).pop();
              onToggle();
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    ChecklistItemModel itemToDelete,
  ) {
    showDialog(
      context: context,
      builder: (deleteDialogContext) => AlertDialog(
        title: const Text('Delete Item?'),
        content: Text(
          'Are you sure you want to delete "${itemToDelete.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              onDelete();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
