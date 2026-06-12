import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/mesa.dart';
import 'legend_item.dart';
import 'mesa_widget.dart';

class MesasGrid extends StatelessWidget {
  final List<Mesa> mesas;
  final ValueChanged<int> onMesaSeleccionada;

  const MesasGrid({
    super.key,
    required this.mesas,
    required this.onMesaSeleccionada,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SELECCIONA MESA',
          style: TextStyle(
            color: AppColors.softWhite,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        _buildLegend(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.blackElegant.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.darkGray,
              width: 1,
            ),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            itemCount: mesas.length,
            itemBuilder: (context, index) {
              final mesa = mesas[index];
              return MesaWidget(
                mesa: mesa,
                onTap: mesa.estado != MesaEstado.ocupada
                    ? () => onMesaSeleccionada(mesa.numero)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        const LegendItem(
          color: AppColors.tableAvailable,
          label: 'Disponible',
        ),
        const SizedBox(width: 16),
        const LegendItem(
          color: AppColors.goldPremium,
          label: 'Seleccionada',
        ),
        const SizedBox(width: 16),
        const LegendItem(
          color: AppColors.tableOccupied,
          label: 'Ocupada',
        ),
      ],
    );
  }
}
