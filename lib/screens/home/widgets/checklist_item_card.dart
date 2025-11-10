import 'package:checklist_app/app/core/utils/priority_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:checklist_app/data/models/checklist_item_model.dart';
import 'package:checklist_app/app/config/themes/app_colors.dart';
import 'package:checklist_app/app/core/extensions/context_extension.dart';

class ChecklistItemCard extends StatelessWidget {
  final ChecklistItemModel item;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const ChecklistItemCard({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Slidable(
        key: ValueKey(item.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onEdit(),
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => _showDeleteConfirmation(context),
              backgroundColor: AppColors.red,
              foregroundColor: AppColors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Card(
          elevation: 3,
          shadowColor: PriorityUtils.getPriorityColor(
            item.priority,
          ).withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: PriorityUtils.getPriorityColor(
                item.priority,
              ).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _showCompleteConfirmation(context),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: item.isCompleted
                              ? PriorityUtils.getPriorityColor(item.priority)
                              : context.colorScheme.outline.withOpacity(0.5),
                          width: 2.5,
                        ),
                        color: item.isCompleted
                            ? PriorityUtils.getPriorityColor(item.priority)
                            : AppColors.transparent,
                      ),
                      child: item.isCompleted
                          ? const Icon(
                              Icons.check,
                              color: AppColors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: context.textTheme.titleMedium?.copyWith(
                            decoration: item.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: item.isCompleted
                                ? context.colorScheme.onSurfaceVariant
                                : null,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (item.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.description,
                            style: context.textTheme.bodyMedium?.copyWith(
                              decoration: item.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 8),
                        // Meta info
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _buildPriorityChip(context),
                            _buildDateChip(context),
                            if (item.dueDate != null)
                              _buildDueDateChip(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: PriorityUtils.getPriorityColor(item.priority).withAlpha(51),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: PriorityUtils.getPriorityColor(item.priority),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            PriorityUtils.getPriorityIcon(item.priority),
            size: 14,
            color: PriorityUtils.getPriorityColor(item.priority),
          ),
          const SizedBox(width: 4),
          Text(
            item.priority.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: PriorityUtils.getPriorityColor(item.priority),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateChip(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final date = item.isCompleted && item.completedAt != null
        ? item.completedAt!
        : item.createdAt;
    final label = item.isCompleted && item.completedAt != null
        ? 'Completed'
        : 'Created';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.isCompleted ? Icons.check_circle : Icons.access_time,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            '$label ${_formatDate(date)}',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDueDateChip(BuildContext context) {
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: dueDateColor.withAlpha(51),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: dueDateColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOverdue ? Icons.warning : Icons.event,
            size: 14,
            color: dueDateColor,
          ),
          const SizedBox(width: 4),
          Text(
            'Due ${_formatDate(dueDate)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: dueDateColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat.jm().format(date);
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat.MMMd().format(date);
    }
  }

  void _showCompleteConfirmation(BuildContext context) {
    if (item.isCompleted) {
      onToggle();
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Mark as Complete?'),
        content: Text('Mark "${item.title}" as completed?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.pop();
              onToggle();
            },
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Item?'),
        content: Text('Are you sure you want to delete "${item.title}"?'),
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
