import 'package:flutter/material.dart';
import 'package:checklist_app/app/config/themes/app_colors.dart';
import 'package:checklist_app/screens/dashboard/widgets/dashboard_stat_card.dart';

class DashboardOverviewCards extends StatelessWidget {
  final int totalItems;
  final int completedItems;
  final int incompleteItems;
  final int completionRate;

  const DashboardOverviewCards({
    super.key,
    required this.totalItems,
    required this.completedItems,
    required this.incompleteItems,
    required this.completionRate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DashboardStatCard(
                title: 'Total Items',
                value: totalItems.toString(),
                icon: Icons.list_alt,
                color: AppColors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DashboardStatCard(
                title: 'Completed',
                value: completedItems.toString(),
                icon: Icons.check_circle,
                color: AppColors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DashboardStatCard(
                title: 'Pending',
                value: incompleteItems.toString(),
                icon: Icons.pending,
                color: AppColors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DashboardStatCard(
                title: 'Completion Rate',
                value: '$completionRate%',
                icon: Icons.trending_up,
                color: AppColors.tertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
