import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PersonasSelector extends StatelessWidget {
  final int cantidadPersonas;
  final ValueChanged<int> onCantidadChanged;

  const PersonasSelector({
    super.key,
    required this.cantidadPersonas,
    required this.onCantidadChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.people,
              color: AppColors.goldPremium,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'NÚMERO DE PERSONAS',
              style: TextStyle(
                color: AppColors.softWhite,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.darkGray,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: cantidadPersonas > 1
                    ? () => onCantidadChanged(cantidadPersonas - 1)
                    : null,
                icon: const Icon(Icons.remove),
                iconSize: 28,
                color: AppColors.softWhite,
              ),
              Text(
                cantidadPersonas.toString(),
                style: const TextStyle(
                  color: AppColors.softWhite,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: cantidadPersonas < 10
                    ? () => onCantidadChanged(cantidadPersonas + 1)
                    : null,
                icon: const Icon(Icons.add),
                iconSize: 28,
                color: AppColors.softWhite,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
