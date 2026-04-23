import 'package:flutter/material.dart';
import 'package:sunspot/core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color getColor() {
    switch (status.toLowerCase()) {
      case "approved":
      case "completed":
      case "done":
        return AppColors.success;
      case "pending":
      case "in_progress":
      case "active":
        return AppColors.warning;
      case "rejected":
      case "cancelled":
      case "error":
        return AppColors.error;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: getColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(color: getColor(), fontSize: 12),
      ),
    );
  }
}
