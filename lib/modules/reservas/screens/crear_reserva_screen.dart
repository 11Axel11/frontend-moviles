import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_format.dart';
import '../../restaurantes/models/restaurante.dart';
import '../../usuarios/state/usuario_session.dart';
import '../data/mesa_repository.dart';
import '../data/reserva_repository.dart';
import '../models/mesa.dart';
import 'confirmacion_reserva_screen.dart';

class CrearReservaScreen extends StatefulWidget {
  const CrearReservaScreen({super.key, required this.restaurante});

  final Restaurante restaurante;

  @override
  State<CrearReservaScreen> createState() => _CrearReservaScreenState();
}

class _CrearReservaScreenState extends State<CrearReservaScreen> {
  final _api = ApiClient();
  late final MesaRepository _mesaRepository = MesaRepository(_api);
  late final ReservaRepository _reservaRepository = ReservaRepository(_api);
  late DateTime _fecha;
  late String _hora;
  List<Mesa> _mesas = const [];
  int? _mesaId;
  Mesa? _mesaSeleccionada;
  int _personas = 2;
  bool _cargandoMesas = false;
  bool _guardando = false;
  String? _error;

  List<String> get _horas => widget.restaurante.horarios;
  bool get _capacidadValida => _mesaSeleccionada == null || _personas <= _mesaSeleccionada!.cantidadSillas;

  @override
  void initState() {
    super.initState();
    _fecha = DateTime.now();
    _hora = _horas.isEmpty ? '' : _horas.first;
    if (_hora.isNotEmpty) _cargarMesas();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  Future<void> _cargarMesas() async {
    if (_hora.isEmpty) return;
    setState(() {
      _cargandoMesas = true;
      _error = null;
      _mesaId = null;
      _mesaSeleccionada = null;
    });
    try {
      final mesas = await _mesaRepository.disponibles(
        restauranteId: widget.restaurante.id,
        fecha: apiDate(_fecha),
        hora: _hora,
      );
      if (!mounted) return;
      setState(() {
        _mesas = mesas;
        _cargandoMesas = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.message;
        _cargandoMesas = false;
      });
    }
  }

  Future<void> _seleccionarFecha() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selected == null) return;
    setState(() => _fecha = selected);
    await _cargarMesas();
  }

  Future<void> _confirmar() async {
    final mesaId = _mesaId;
    final usuario = UsuarioSession.current;
    if (mesaId == null || usuario == null || _hora.isEmpty) return;
    if (_mesaSeleccionada != null && _personas > _mesaSeleccionada!.cantidadSillas) {
      setState(() => _error = 'La mesa seleccionada tiene capacidad para ${_mesaSeleccionada!.cantidadSillas} personas.');
      return;
    }
    setState(() => _guardando = true);
    try {
      final reserva = await _reservaRepository.crear(
        restauranteId: widget.restaurante.id,
        mesaId: mesaId,
        usuarioId: usuario.id,
        fecha: apiDate(_fecha),
        hora: _hora,
        horaFin: addMinutesToTime(_hora, 30),
        cantidadPersonas: _personas,
      );
      if (!mounted) return;
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmacionReservaScreen(
            reserva: reserva,
            restaurante: widget.restaurante,
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackElegant,
      appBar: AppBar(title: Text(widget.restaurante.nombre)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle('FECHA'),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _seleccionarFecha,
                icon: const Icon(Icons.calendar_month),
                label: Text(displayDate(_fecha)),
              ),
              const SizedBox(height: 28),
              const _SectionTitle('HORARIO'),
              const SizedBox(height: 12),
              if (_horas.isEmpty)
                const Text('Este restaurante no tiene horarios configurados.', style: TextStyle(color: AppColors.lightGray))
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _horas.map((hora) => ChoiceChip(
                        label: Text(hora),
                        selected: _hora == hora,
                        onSelected: (_) async {
                          setState(() => _hora = hora);
                          await _cargarMesas();
                        },
                        selectedColor: AppColors.goldPremium,
                      )).toList(),
                ),
              const SizedBox(height: 28),
              const _SectionTitle('MESAS DISPONIBLES'),
              const SizedBox(height: 12),
              _buildTables(),
              const SizedBox(height: 28),
              const _SectionTitle('NÚMERO DE PERSONAS'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: _personas > 1 ? () => setState(() => _personas--) : null, icon: const Icon(Icons.remove), color: Colors.white),
                  Text('$_personas', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: _personas < 20 ? () => setState(() => _personas++) : null, icon: const Icon(Icons.add), color: Colors.white),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(_error!, style: const TextStyle(color: Colors.redAccent)),
              ],
              if (!_capacidadValida) ...[
                const SizedBox(height: 8),
                Text(
                  'La mesa seleccionada admite ${_mesaSeleccionada!.cantidadSillas} personas como máximo.',
                  style: const TextStyle(color: Colors.orangeAccent),
                ),
              ],
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _mesaId != null && _capacidadValida && !_guardando ? _confirmar : null,
                  child: _guardando ? const CircularProgressIndicator() : const Text('Confirmar reserva'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTables() {
    if (_cargandoMesas) return const Center(child: CircularProgressIndicator());
    if (_mesas.isEmpty) return const Text('No hay mesas disponibles para esta fecha y horario.', style: TextStyle(color: AppColors.lightGray));
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _mesas.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12),
      itemBuilder: (_, index) {
        final mesa = _mesas[index];
        final selected = mesa.id == _mesaId;
        return InkWell(
          onTap: () => setState(() {
            _mesaId = mesa.id;
            _mesaSeleccionada = mesa;
          }),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: selected ? AppColors.goldPremium : AppColors.tableAvailable,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: selected ? AppColors.goldPremium : AppColors.tableAvailableBorder, width: 2),
            ),
            child: Center(child: Text('${mesa.numero}\n${mesa.cantidadSillas} sillas', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Text(title, style: const TextStyle(color: AppColors.softWhite, fontWeight: FontWeight.bold, letterSpacing: 1.1));
}
