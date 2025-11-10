import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:checklist_app/app/core/constants/route_constants.dart';
import 'package:checklist_app/app/core/extensions/context_extension.dart';

class DashboardEmptyState extends StatelessWidget {
  const DashboardEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(context),
            const SizedBox(height: 32),
            _buildTitle(context),
            const SizedBox(height: 12),
            _buildDescription(context),
            const SizedBox(height: 32),
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colorScheme.primary.withOpacity(0.1),
            context.colorScheme.primary.withOpacity(0.05),
          ],
        ),
      ),
      child: Icon(
        Icons.analytics_outlined,
        size: 80,
        color: context.colorScheme.primary.withOpacity(0.6),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'No Data Yet',
      style: context.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      'Add some checklist items to see\nyour statistics and insights',
      textAlign: TextAlign.center,
      style: context.textTheme.bodyLarge?.copyWith(
        color: context.colorScheme.onSurfaceVariant,
        height: 1.5,
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => context.go(RouteConstants.home),
      icon: const Icon(Icons.add),
      label: const Text('Add Your First Item'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
