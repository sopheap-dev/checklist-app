import 'package:checklist_app/screens/home/cubit/checklist_cubit.dart';
import 'package:checklist_app/screens/home/cubit/checklist_state.dart';
import 'package:checklist_app/screens/home/widgets/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:checklist_app/app/config/themes/app_colors.dart';

class ChecklistAppBarActions extends StatelessWidget {
  final VoidCallback onDeleteCompleted;
  final VoidCallback onDeleteAll;

  const ChecklistAppBarActions({
    super.key,
    required this.onDeleteCompleted,
    required this.onDeleteAll,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _FilterIconButton(onPressed: () => _showFilterBottomSheet(context)),
        _BulkActionsMenu(
          onDeleteCompleted: onDeleteCompleted,
          onDeleteAll: onDeleteAll,
        ),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<ChecklistCubit>(),
        child: const FilterBottomSheet(),
      ),
    );
  }
}

/// Filter icon button with badge indicator
class _FilterIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _FilterIconButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChecklistCubit, ChecklistState>(
      builder: (context, state) {
        final hasFilters = state.hasActiveFilters;

        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: onPressed,
              tooltip: 'Filter',
            ),
            if (hasFilters)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _BulkActionsMenu extends StatelessWidget {
  final VoidCallback onDeleteCompleted;
  final VoidCallback onDeleteAll;

  const _BulkActionsMenu({
    required this.onDeleteCompleted,
    required this.onDeleteAll,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      tooltip: 'More actions',
      onSelected: (value) {
        switch (value) {
          case 'delete_completed':
            onDeleteCompleted();
            break;
          case 'delete_all':
            onDeleteAll();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'delete_completed',
          child: Row(
            children: [
              Icon(Icons.delete_sweep, size: 20),
              SizedBox(width: 12),
              Text('Delete Completed'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete_all',
          child: Row(
            children: [
              Icon(Icons.delete_forever, size: 20, color: AppColors.red),
              SizedBox(width: 12),
              Text('Delete All', style: TextStyle(color: AppColors.red)),
            ],
          ),
        ),
      ],
    );
  }
}
