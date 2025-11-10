import 'package:checklist_app/app/core/utils/checklist_filter_util.dart';
import 'package:flutter/material.dart';

class ChecklistSortChips extends StatelessWidget {
  final ChecklistSortType currentSort;
  final ValueChanged<ChecklistSortType> onSortChanged;

  const ChecklistSortChips({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.sort_rounded,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Text(
            'Sort by:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildSortChip(
                    context,
                    'Priority',
                    ChecklistSortType.priority,
                  ),
                  const SizedBox(width: 6),
                  _buildSortChip(context, 'Newest', ChecklistSortType.dateNew),
                  const SizedBox(width: 6),
                  _buildSortChip(context, 'Oldest', ChecklistSortType.dateOld),
                  const SizedBox(width: 6),
                  _buildSortChip(context, 'Name', ChecklistSortType.name),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(
    BuildContext context,
    String label,
    ChecklistSortType sortType,
  ) {
    final isSelected = sortType == currentSort;
    final colorScheme = Theme.of(context).colorScheme;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onSortChanged(sortType),
      selectedColor: colorScheme.primaryContainer,
      checkmarkColor: colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      side: BorderSide(
        color: isSelected
            ? colorScheme.primary.withOpacity(0.3)
            : colorScheme.outlineVariant,
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
