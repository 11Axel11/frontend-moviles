import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../reservas/screens/crear_reserva_screen.dart';
import '../models/restaurante.dart';

class RestauranteDetalleScreen extends StatelessWidget {
  final Restaurante restaurante;

  const RestauranteDetalleScreen({
    super.key,
    required this.restaurante,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softWhite,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.blackElegant,
            foregroundColor: AppColors.softWhite,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                restaurante.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.softWhite,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: AppColors.blackElegant,
                    child: const Icon(
                      Icons.restaurant,
                      size: 96,
                      color: AppColors.goldPremium,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.15),
                          Colors.black.withValues(alpha: 0.80),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _InfoBadge(
                        icon: Icons.star,
                        text: restaurante.calificacion.toString(),
                      ),
                      const SizedBox(width: 10),
                      _InfoBadge(
                        icon: Icons.category,
                        text: restaurante.categoria,
                      ),
                      const SizedBox(width: 10),
                      _InfoBadge(
                        icon: restaurante.abierto
                            ? Icons.check_circle
                            : Icons.cancel,
                        text: restaurante.abierto ? 'Abierto' : 'Cerrado',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Descripción',
                    style: TextStyle(
                      color: AppColors.blackElegant,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    restaurante.descripcion,
                    style: const TextStyle(
                      color: AppColors.darkGray,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  _DetailItem(
                    icon: Icons.location_on,
                    title: 'Ubicación',
                    value: restaurante.ubicacion,
                  ),

                  const SizedBox(height: 14),

                  _DetailItem(
                    icon: Icons.access_time,
                    title: 'Horario',
                    value: restaurante.horario,
                  ),

                  const SizedBox(height: 14),

                  _DetailItem(
                    icon: Icons.table_restaurant,
                    title: 'Mesas disponibles',
                    value: '${restaurante.mesasDisponibles} mesas disponibles',
                  ),

                  const SizedBox(height: 28),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.lightGray,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reserva disponible',
                          style: TextStyle(
                            color: AppColors.blackElegant,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          restaurante.mesasDisponibles > 0
                              ? 'Este restaurante tiene mesas disponibles para reservar.'
                              : 'Actualmente no hay mesas disponibles en este restaurante.',
                          style: const TextStyle(
                            color: AppColors.darkGray,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: restaurante.mesasDisponibles > 0 &&
                                    restaurante.abierto
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CrearReservaScreen(
                                          restaurante: restaurante,
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.goldPremium,
                              foregroundColor: AppColors.blackElegant,
                              disabledBackgroundColor: AppColors.lightGray,
                              disabledForegroundColor: AppColors.darkGray,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Reservar ahora',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoBadge({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: AppColors.goldPremium.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.goldPremium,
            size: 16,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.blackElegant,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.blackElegant,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: AppColors.goldPremium,
            size: 22,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.blackElegant,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.darkGray,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}