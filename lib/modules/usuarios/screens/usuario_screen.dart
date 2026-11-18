import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../reservas/screens/crear_reserva_screen.dart';
import '../../restaurantes/models/restaurante.dart';
import '../data/usuario_repository.dart';
import '../state/usuario_session.dart';

class UsuarioScreen extends StatefulWidget {
  const UsuarioScreen({super.key, required this.restaurante});

  final Restaurante restaurante;

  @override
  State<UsuarioScreen> createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _apellido = TextEditingController();
  final _email = TextEditingController();
  final _telefono = TextEditingController();
  final _api = ApiClient();
  late final _repository = UsuarioRepository(_api);
  bool _guardando = false;
  String? _error;

  @override
  void dispose() {
    _nombre.dispose();
    _apellido.dispose();
    _email.dispose();
    _telefono.dispose();
    _api.dispose();
    super.dispose();
  }

  Future<void> _continuar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _guardando = true;
      _error = null;
    });
    try {
      final usuario = await _repository.crear(
        nombre: _nombre.text,
        apellido: _apellido.text,
        email: _email.text,
        telefono: _telefono.text,
      );
      UsuarioSession.set(usuario);
      if (!mounted) return;
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CrearReservaScreen(restaurante: widget.restaurante)),
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
      appBar: AppBar(title: const Text('Tus datos')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Necesitamos tus datos para asociar la reserva.', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              _field(_nombre, 'Nombre'),
              _field(_apellido, 'Apellido'),
              _field(_email, 'Correo electrónico', keyboardType: TextInputType.emailAddress, validator: (value) {
                if (value == null || !value.contains('@')) return 'Ingresa un correo válido';
                return null;
              }),
              _field(_telefono, 'Teléfono', keyboardType: TextInputType.phone),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.redAccent)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _guardando ? null : _continuar,
                  child: _guardando ? const CircularProgressIndicator() : const Text('Continuar con la reserva'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator ?? (value) => value == null || value.trim().isEmpty ? 'Este campo es requerido' : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.softWhite,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
