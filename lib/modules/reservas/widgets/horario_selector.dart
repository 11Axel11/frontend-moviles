import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'time_chip.dart';

class HorarioSelector extends StatelessWidget {
  final List<String> horasDisponibles;
  final String horaSeleccionada;
  final ValueChanged<String> onHoraChanged;

  const HorarioSelector({
    super.key,
    required this.horasDisponibles,
    required this.horaSeleccionada,
    required this.onHoraChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HORARIO',
          style: TextStyle(
            color: AppColors.softWhite,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: horasDisponibles.map((hora) {
            final seleccionada = hora == horaSeleccionada;
            return TimeChip(
              label: hora,
              seleccionada: seleccionada,
              onTap: () => onHoraChanged(hora),
            );
          }).toList(),
        ),
      ],
    );
  }
}
