import 'package:flutter/material.dart';
import 'package:checklist_app/app/core/extensions/context_extension.dart';

class DashboardSectionTitle extends StatelessWidget {
  final String title;

  const DashboardSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Row(
        children: [
          _buildAccentBar(context),
          const SizedBox(width: 12),
          _buildTitle(context),
        ],
      ),
    );
  }

  Widget _buildAccentBar(BuildContext context) {
    return Container(
      width: 4,
      height: 28,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.colorScheme.primary,
            context.colorScheme.primary.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        letterSpacing: -0.5,
      ),
    );
  }
}
