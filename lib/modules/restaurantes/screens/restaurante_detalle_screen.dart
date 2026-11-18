import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../reservas/screens/crear_reserva_screen.dart';
import '../../usuarios/screens/usuario_screen.dart';
import '../../usuarios/state/usuario_session.dart';
import '../models/restaurante.dart';

class RestauranteDetalleScreen extends StatelessWidget {
  const RestauranteDetalleScreen({super.key, required this.restaurante});

  final Restaurante restaurante;

  @override
  Widget build(BuildContext context) {
    final puedeReservar = restaurante.mesasDisponibles > 0 && restaurante.activo;
    return Scaffold(
      appBar: AppBar(title: Text(restaurante.nombre)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (restaurante.imagenUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  restaurante.imagenUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const _ImagePlaceholder(),
                ),
              )
            else
              const _ImagePlaceholder(),
            const SizedBox(height: 20),
            Text(restaurante.nombre, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(restaurante.descripcion),
            const SizedBox(height: 24),
            _InfoRow(icon: Icons.location_on_outlined, label: restaurante.ubicacion),
            _InfoRow(icon: Icons.phone_outlined, label: restaurante.telefono),
            if (restaurante.horarios.isNotEmpty)
              _InfoRow(icon: Icons.schedule, label: restaurante.horarios.join('\n')),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.goldPremium.withValues(alpha: .16),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.table_restaurant, color: AppColors.blackElegant),
                  const SizedBox(width: 10),
                  Expanded(child: Text('${restaurante.mesasDisponibles} mesas disponibles')),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: puedeReservar
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UsuarioSession.current == null
                                ? UsuarioScreen(restaurante: restaurante)
                                : CrearReservaScreen(restaurante: restaurante),
                          ),
                        )
                    : null,
                child: Text(puedeReservar ? 'Reservar ahora' : 'No disponible'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) => Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(color: AppColors.blackElegant, borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.restaurant, color: AppColors.goldPremium, size: 70),
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.goldPremium),
            const SizedBox(width: 12),
            Expanded(child: Text(label)),
          ],
        ),
      );
}
