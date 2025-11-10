import 'package:flutter/material.dart';
import 'package:checklist_app/app/config/themes/app_colors.dart';
import 'package:checklist_app/app/core/extensions/context_extension.dart';

class DashboardWelcomeHeader extends StatelessWidget {
  final int totalItems;
  final int completedItems;

  const DashboardWelcomeHeader({
    super.key,
    required this.totalItems,
    required this.completedItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colorScheme.primary,
            context.colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreeting(context),
          const SizedBox(height: 8),
          _buildSummary(context),
          if (totalItems > 0 && completedItems > 0) ...[
            const SizedBox(height: 16),
            _buildCompletedBadge(context),
          ],
        ],
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    return Text(
      _getGreeting(),
      style: context.textTheme.headlineSmall?.copyWith(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    return Text(
      totalItems > 0
          ? 'You have $totalItems ${totalItems == 1 ? 'item' : 'items'} in your checklist'
          : 'Start managing your tasks',
      style: context.textTheme.bodyLarge?.copyWith(
        color: AppColors.white.withOpacity(0.9),
      ),
    );
  }

  Widget _buildCompletedBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 16, color: AppColors.white),
          const SizedBox(width: 8),
          Text(
            '$completedItems ${completedItems == 1 ? 'task completed' : 'tasks completed'}',
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning! 👋';
    } else if (hour < 17) {
      return 'Good Afternoon! ☀️';
    } else {
      return 'Good Evening! 🌙';
    }
  }
}
