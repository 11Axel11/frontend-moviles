import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../restaurantes/models/restaurante.dart';

class ReservaConfirmacionScreen extends StatelessWidget {
  final Restaurante restaurante;
  final String fecha;
  final String hora;
  final int mesa;
  final int personas;

  const ReservaConfirmacionScreen({
    super.key,
    required this.restaurante,
    required this.fecha,
    required this.hora,
    required this.mesa,
    required this.personas,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackElegant,
      body: Column(
        children: [
          // Top half - dark background
          Expanded(
            flex: 1,
            child: Container(
              color: AppColors.blackElegant,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Yellow circular checkmark
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.goldPremium,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.blackElegant,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '¡Reserva confirmada!',
                      style: TextStyle(
                        color: AppColors.softWhite,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '¿Necesitas algo más?',
                      style: TextStyle(
                        color: AppColors.lightGray,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom half - white card with rounded top corners
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.softWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant section
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.goldPremium.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.restaurant,
                            color: AppColors.goldPremium,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                restaurante.nombre,
                                style: const TextStyle(
                                  color: AppColors.blackElegant,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                restaurante.categoria,
                                style: const TextStyle(
                                  color: AppColors.darkGray,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Details rows
                    _buildDetailRow(
                      icon: Icons.calendar_today,
                      label: 'FECHA',
                      value: fecha,
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow(
                      icon: Icons.access_time,
                      label: 'HORA',
                      value: hora,
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow(
                      icon: Icons.tag,
                      label: 'MESA',
                      value: 'Mesa $mesa',
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow(
                      icon: Icons.people,
                      label: 'PERSONAS',
                      value: '$personas personas',
                    ),
                    const SizedBox(height: 40),
                    // Buttons
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.goldPremium,
                          foregroundColor: AppColors.blackElegant,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Ver mis reservas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.darkGray,
                          side: const BorderSide(
                            color: AppColors.lightGray,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Nueva reservación',
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.goldPremium.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppColors.goldPremium,
            size: 22,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.darkGray,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.blackElegant,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
