import 'package:checklist_app/app/core/utils/priority_util.dart';
import 'package:checklist_app/screens/home/cubit/checklist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:checklist_app/data/models/checklist_item_model.dart';
import 'package:go_router/go_router.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late bool _tempShowCompletedOnly;
  late bool _tempShowIncompleteOnly;
  late Priority? _tempFilterByPriority;

  @override
  void initState() {
    super.initState();
    final state = context.read<ChecklistCubit>().state;
    _tempShowCompletedOnly = state.showCompletedOnly;
    _tempShowIncompleteOnly = state.showIncompleteOnly;
    _tempFilterByPriority = state.filterByPriority;
  }

  void _applyFilters() {
    final cubit = context.read<ChecklistCubit>();

    if (_tempShowCompletedOnly && !_tempShowIncompleteOnly) {
      cubit.filterByCompletion(showCompleted: true, showIncomplete: false);
    } else if (_tempShowIncompleteOnly && !_tempShowCompletedOnly) {
      cubit.filterByCompletion(showCompleted: false, showIncomplete: true);
    } else {
      cubit.filterByCompletion(showCompleted: false, showIncomplete: false);
    }

    cubit.filterByPriority(_tempFilterByPriority);

    context.pop();
  }

  void _clearAllFilters() {
    setState(() {
      _tempShowCompletedOnly = false;
      _tempShowIncompleteOnly = false;
      _tempFilterByPriority = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.filter_list, size: 28),
              const SizedBox(width: 12),
              Text(
                'Filter & Sort',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _clearAllFilters,
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Text(
            'Status',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('Show All'),
                selected: !_tempShowCompletedOnly && !_tempShowIncompleteOnly,
                onSelected: (_) {
                  setState(() {
                    _tempShowCompletedOnly = false;
                    _tempShowIncompleteOnly = false;
                  });
                },
              ),
              FilterChip(
                label: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 16),
                    SizedBox(width: 4),
                    Text('Completed Only'),
                  ],
                ),
                selected: _tempShowCompletedOnly,
                onSelected: (_) {
                  setState(() {
                    _tempShowCompletedOnly = !_tempShowCompletedOnly;
                    if (_tempShowCompletedOnly) {
                      _tempShowIncompleteOnly = false;
                    }
                  });
                },
              ),
              FilterChip(
                label: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.pending, size: 16),
                    SizedBox(width: 4),
                    Text('Pending Only'),
                  ],
                ),
                selected: _tempShowIncompleteOnly,
                onSelected: (_) {
                  setState(() {
                    _tempShowIncompleteOnly = !_tempShowIncompleteOnly;
                    if (_tempShowIncompleteOnly) {
                      _tempShowCompletedOnly = false;
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          Text(
            'Priority',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('All Priorities'),
                selected: _tempFilterByPriority == null,
                onSelected: (_) {
                  setState(() {
                    _tempFilterByPriority = null;
                  });
                },
              ),
              ...Priority.values.map((priority) {
                final isSelected = _tempFilterByPriority == priority;
                return FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        PriorityUtils.getPriorityIcon(priority),
                        size: 16,
                        color: PriorityUtils.getPriorityColor(priority),
                      ),
                      const SizedBox(width: 4),
                      Text(priority.displayName),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _tempFilterByPriority = isSelected ? null : priority;
                    });
                  },
                  selectedColor: PriorityUtils.getPriorityColor(
                    priority,
                  ).withAlpha(51),
                  side: BorderSide(
                    color: PriorityUtils.getPriorityColor(priority),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _applyFilters,
              icon: const Icon(Icons.check),
              label: const Text('Apply Filters'),
              style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
