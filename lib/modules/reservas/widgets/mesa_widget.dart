import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/mesa.dart';

class MesaWidget extends StatelessWidget {
  final Mesa mesa;
  final VoidCallback? onTap;

  const MesaWidget({
    super.key,
    required this.mesa,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color tableColor;
    Color borderColor;

    switch (mesa.estado) {
      case MesaEstado.disponible:
        tableColor = AppColors.tableAvailable;
        borderColor = AppColors.tableAvailableBorder;
        break;
      case MesaEstado.seleccionada:
        tableColor = AppColors.goldPremium;
        borderColor = AppColors.goldPremium;
        break;
      case MesaEstado.ocupada:
        tableColor = AppColors.tableOccupied;
        borderColor = AppColors.tableOccupiedBorder;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.blackElegant.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              // Silla superior
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.blackElegant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              // Silla inferior
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.blackElegant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              // Silla izquierda
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.blackElegant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              // Silla derecha
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.blackElegant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              // Mesa central
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: tableColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: borderColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      mesa.numero.toString(),
                      style: TextStyle(
                        color: mesa.estado == MesaEstado.ocupada
                            ? AppColors.lightGray
                            : AppColors.blackElegant,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
