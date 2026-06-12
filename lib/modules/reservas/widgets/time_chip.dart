import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TimeChip extends StatelessWidget {
  final String label;
  final bool seleccionada;
  final VoidCallback onTap;

  const TimeChip({
    super.key,
    required this.label,
    required this.seleccionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: seleccionada ? AppColors.goldPremium : AppColors.darkGray,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.softWhite,
            fontSize: 14,
            fontWeight: seleccionada ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
