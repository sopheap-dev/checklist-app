import 'package:checklist_app/app/config/themes/app_colors.dart';
import 'package:checklist_app/app/core/extensions/context_extension.dart';
import 'package:checklist_app/app/core/utils/priority_util.dart';
import 'package:checklist_app/app/core/extensions/stats_extensions.dart';
import 'package:flutter/material.dart';
import 'package:checklist_app/data/models/checklist_item_model.dart';

class PriorityBreakdown extends StatelessWidget {
  final Map<String, int> stats;

  const PriorityBreakdown({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final priorities = [
      {
        'name': 'Low',
        'count': stats.lowPriority,
        'priority': Priority.low,
        'icon': Icons.arrow_downward,
      },
      {
        'name': 'Medium',
        'count': stats.mediumPriority,
        'priority': Priority.medium,
        'icon': Icons.remove,
      },
      {
        'name': 'High',
        'count': stats.highPriority,
        'priority': Priority.high,
        'icon': Icons.arrow_upward,
      },
      {
        'name': 'Urgent',
        'count': stats.urgentPriority,
        'priority': Priority.urgent,
        'icon': Icons.priority_high,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: priorities.map((priorityData) {
          final priority = priorityData['priority'] as Priority;
          final count = priorityData['count'] as int;
          final name = priorityData['name'] as String;
          final icon = priorityData['icon'] as IconData;
          final color = PriorityUtils.getPriorityColor(priority);
          final percentage = stats.totalItems > 0
              ? (count / stats.totalItems) * 100
              : 0.0;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: context.colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withAlpha(51),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: context.colorScheme.surfaceVariant,
                        color: color,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$count',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: color,
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
