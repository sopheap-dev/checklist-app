import 'package:flutter/material.dart';
import 'package:checklist_app/app/config/themes/app_colors.dart';
import 'package:checklist_app/app/core/extensions/context_extension.dart';

class ChecklistStatsBar extends StatelessWidget {
  final int total;
  final int completed;
  final int pending;

  const ChecklistStatsBar({
    super.key,
    required this.total,
    required this.completed,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withOpacity(0.4),
            colorScheme.primaryContainer.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _buildStatItem(
              context,
              'Total',
              total,
              Icons.list_alt_rounded,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: colorScheme.outlineVariant,
          ),
          Expanded(
            child: _buildStatItem(
              context,
              'Completed',
              completed,
              Icons.check_circle_rounded,
              color: AppColors.green,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: colorScheme.outlineVariant,
          ),
          Expanded(
            child: _buildStatItem(
              context,
              'Pending',
              pending,
              Icons.pending_rounded,
              color: AppColors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    int value,
    IconData icon, {
    Color? color,
  }) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final statColor = color ?? colorScheme.primary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: statColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 22, color: statColor),
        ),
        const SizedBox(height: 10),
        Text(
          value.toString(),
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: statColor,
            fontSize: 26,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
