import 'package:flutter/material.dart';
import 'package:checklist_app/app/core/extensions/context_extension.dart';

class ChecklistEmptyState extends StatelessWidget {
  final bool hasFilters;
  final bool hasItems;

  const ChecklistEmptyState({
    super.key,
    required this.hasFilters,
    required this.hasItems,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checklist_rounded,
            size: 120,
            color: context.colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            hasItems ? 'No items match your filters' : 'No checklist items yet',
            style: context.textTheme.headlineSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasItems
                ? 'Try adjusting your filters'
                : 'Tap the + button to add your first item',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
