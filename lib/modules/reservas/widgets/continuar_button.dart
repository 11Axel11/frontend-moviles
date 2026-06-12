import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ContinuarButton extends StatelessWidget {
  final bool habilitado;
  final VoidCallback onPressed;

  const ContinuarButton({
    super.key,
    required this.habilitado,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: habilitado ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: habilitado ? AppColors.goldPremium : AppColors.darkGray,
          foregroundColor: AppColors.softWhite,
          disabledBackgroundColor: AppColors.darkGray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Continuar',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
