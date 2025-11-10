import 'dart:math' as math;
import 'package:checklist_app/app/core/utils/priority_util.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:checklist_app/data/models/checklist_item_model.dart';
import 'package:checklist_app/app/config/themes/app_colors.dart';
import 'package:checklist_app/app/core/extensions/context_extension.dart';
import 'package:checklist_app/app/core/extensions/stats_extensions.dart';

class PriorityChart extends StatelessWidget {
  final Map<String, int> stats;

  const PriorityChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final maxPriority = math.max(
      math.max(stats.lowPriority, stats.mediumPriority),
      math.max(stats.highPriority, stats.urgentPriority),
    );
    return Container(
      height: 320,
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
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (maxPriority + 2).toDouble(),
          barGroups: [
            _buildBarGroup(0, stats.lowPriority.toDouble(), Priority.low),
            _buildBarGroup(1, stats.mediumPriority.toDouble(), Priority.medium),
            _buildBarGroup(2, stats.highPriority.toDouble(), Priority.high),
            _buildBarGroup(3, stats.urgentPriority.toDouble(), Priority.urgent),
          ],
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const titles = ['Low', 'Medium', 'High', 'Urgent'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      titles[value.toInt()],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Priority priority) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: PriorityUtils.getPriorityColor(priority),
          width: 40,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }
}
