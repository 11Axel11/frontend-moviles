import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/restaurante.dart';

class RestauranteCard extends StatelessWidget {
  const RestauranteCard({super.key, required this.restaurante, required this.onTap});

  final Restaurante restaurante;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              _RestaurantImage(url: restaurante.imagenUrl),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(restaurante.nombre, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(restaurante.ubicacion),
                    const SizedBox(height: 8),
                    Text(
                      restaurante.mesasDisponibles > 0
                          ? '${restaurante.mesasDisponibles} mesas disponibles'
                          : 'Sin mesas disponibles',
                      style: const TextStyle(color: AppColors.darkGray, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.goldPremium),
            ],
          ),
        ),
      ),
    );
  }
}

class _RestaurantImage extends StatelessWidget {
  const _RestaurantImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      height: 86,
      decoration: BoxDecoration(color: AppColors.blackElegant, borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: url.isEmpty
          ? const Icon(Icons.restaurant, color: AppColors.goldPremium, size: 38)
          : Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(Icons.restaurant, color: AppColors.goldPremium, size: 38),
            ),
    );
  }
}
