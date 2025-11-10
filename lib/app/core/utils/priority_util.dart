import 'package:flutter/material.dart';
import 'package:checklist_app/data/models/checklist_item_model.dart';
import 'package:checklist_app/app/config/themes/app_colors.dart';

class PriorityUtils {
  static Color getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return AppColors.green;
      case Priority.medium:
        return AppColors.blue;
      case Priority.high:
        return AppColors.orange;
      case Priority.urgent:
        return AppColors.red;
    }
  }

  static IconData getPriorityIcon(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Icons.arrow_downward;
      case Priority.medium:
        return Icons.remove;
      case Priority.high:
        return Icons.arrow_upward;
      case Priority.urgent:
        return Icons.priority_high;
    }
  }
}
