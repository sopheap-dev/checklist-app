import 'package:checklist_app/screens/home/cubit/checklist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:checklist_app/app/config/themes/app_colors.dart';
import 'package:go_router/go_router.dart';

class DeleteConfirmationDialogs {
  DeleteConfirmationDialogs._();

  static void showDeleteCompleted(BuildContext context, ChecklistCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Completed Items?'),
        content: const Text(
          'This will permanently delete all completed items.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cubit.deleteCompletedItems();
              context.pop();
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

  static void showDeleteAll(BuildContext context, ChecklistCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete All Items?'),
        content: const Text(
          'This will permanently delete ALL checklist items. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.canPop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cubit.deleteAllItems();
              context.pop();
            },
            child: const Text(
              'Delete All',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
