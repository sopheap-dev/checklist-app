import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:checklist_app/app/config/themes/app_colors.dart';
import 'package:checklist_app/app/core/extensions/context_extension.dart';

class CompletionChart extends StatelessWidget {
  final int completed;
  final int incomplete;

  const CompletionChart({
    super.key,
    required this.completed,
    required this.incomplete,
  });

  @override
  Widget build(BuildContext context) {
    final total = completed + incomplete;

    if (total == 0) {
      return const SizedBox();
    }

    return Container(
      height: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: completed.toDouble(),
              title: '${(completed / total * 100).round()}%',
              color: AppColors.green,
              radius: 80,
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            PieChartSectionData(
              value: incomplete.toDouble(),
              title: '${(incomplete / total * 100).round()}%',
              color: AppColors.orange,
              radius: 80,
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 50,
        ),
      ),
    );
  }
}
