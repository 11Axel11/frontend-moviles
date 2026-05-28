import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/restaurante.dart';

class RestauranteCard extends StatelessWidget {
  final Restaurante restaurante;
  final VoidCallback onTap;

  const RestauranteCard({
    super.key,
    required this.restaurante,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.softWhite,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: AppColors.blackElegant,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: AppColors.goldPremium,
                  size: 38,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurante.nombre,
                      style: const TextStyle(
                        color: AppColors.blackElegant,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      restaurante.ubicacion,
                      style: const TextStyle(
                        color: AppColors.darkGray,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 15,
                          color: AppColors.goldPremium,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            restaurante.horario,
                            style: const TextStyle(
                              color: AppColors.darkGray,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: restaurante.abierto
                                ? AppColors.goldPremium.withValues(alpha: 0.18)
                                : AppColors.lightGray,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            restaurante.abierto ? 'Abierto' : 'Cerrado',
                            style: TextStyle(
                              color: restaurante.abierto
                                  ? AppColors.blackElegant
                                  : AppColors.darkGray,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          '${restaurante.mesasDisponibles} mesas disponibles',
                          style: const TextStyle(
                            color: AppColors.darkGray,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: AppColors.goldPremium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}