import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../data/reserva_repository.dart';
import '../models/reserva.dart';
import '../../restaurantes/models/restaurante.dart';
import 'crear_reserva_screen.dart';

class ConfirmacionReservaScreen extends StatefulWidget {
  const ConfirmacionReservaScreen({super.key, required this.reserva, required this.restaurante});

  final Reserva reserva;
  final Restaurante restaurante;

  @override
  State<ConfirmacionReservaScreen> createState() => _ConfirmacionReservaScreenState();
}

class _ConfirmacionReservaScreenState extends State<ConfirmacionReservaScreen> {
  final _api = ApiClient();
  late final _repository = ReservaRepository(_api);
  late Reserva _reserva = widget.reserva;
  bool _cargando = true;
  bool _cancelando = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarDetalle();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  Future<void> _cargarDetalle() async {
    try {
      final reserva = await _repository.obtener(widget.reserva.id);
      if (!mounted) return;
      setState(() {
        _reserva = reserva;
        _cargando = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.message;
        _cargando = false;
      });
    }
  }

  Future<void> _cancelar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar reserva'),
        content: const Text('¿Seguro que deseas cancelar esta reserva?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sí, cancelar')),
        ],
      ),
    );
    if (confirmar != true) return;
    setState(() {
      _cancelando = true;
      _error = null;
    });
    try {
      final reserva = await _repository.cancelar(_reserva.id);
      if (!mounted) return;
      setState(() {
        _reserva = reserva;
        _cancelando = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.message;
        _cancelando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de reserva')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              _reserva.estado == 'cancelada' ? Icons.cancel : Icons.check_circle,
              color: _reserva.estado == 'cancelada' ? Colors.redAccent : AppColors.tableAvailable,
              size: 86,
            ),
            const SizedBox(height: 18),
            Text(
              _reserva.estado == 'cancelada' ? 'Reserva cancelada' : '¡Reserva confirmada!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _detail('Reserva', '#${_reserva.id}'),
            _detail('Restaurante', _reserva.restauranteNombre),
            _detail('Mesa', '#${_reserva.mesaId}'),
            _detail('Fecha', _reserva.fechaReserva),
            _detail('Horario', '${_reserva.horaInicio} - ${_reserva.horaFin}'),
            _detail('Personas', '${_reserva.personas}'),
            _detail('Estado', _reserva.estado),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(_error!, style: const TextStyle(color: Colors.redAccent)),
            ],
            const SizedBox(height: 28),
            if (_reserva.estado != 'cancelada')
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _cancelando ? null : _cancelar,
                  child: _cancelando ? const CircularProgressIndicator() : const Text('Cancelar reserva'),
                ),
              ),
            if (_reserva.estado == 'cancelada')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => CrearReservaScreen(restaurante: widget.restaurante)),
                  ),
                  child: const Text('Ver disponibilidad actualizada'),
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('Volver a restaurantes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detail(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 105, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold))),
            Expanded(child: Text(value)),
          ],
        ),
      );
}
