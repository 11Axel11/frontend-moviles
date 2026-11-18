import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../data/restaurante_repository.dart';
import '../models/restaurante.dart';
import '../widgets/restaurante_card.dart';
import 'restaurante_detalle_screen.dart';

class RestaurantesScreen extends StatefulWidget {
  const RestaurantesScreen({super.key});

  @override
  State<RestaurantesScreen> createState() => _RestaurantesScreenState();
}

class _RestaurantesScreenState extends State<RestaurantesScreen> {
  final _api = ApiClient();
  late final _repository = RestauranteRepository(_api);
  final _searchController = TextEditingController();
  List<Restaurante> _restaurantes = const [];
  String _filtro = 'Todos';
  String _busqueda = '';
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarRestaurantes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _api.dispose();
    super.dispose();
  }

  Future<void> _cargarRestaurantes() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final restaurantes = await _repository.listar();
      if (!mounted) return;
      setState(() {
        _restaurantes = restaurantes;
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

  List<Restaurante> get _filtrados => _restaurantes.where((restaurante) {
        final texto = _busqueda.toLowerCase();
        final coincideTexto = restaurante.nombre.toLowerCase().contains(texto) ||
            restaurante.ubicacion.toLowerCase().contains(texto);
        final coincideFiltro = switch (_filtro) {
          'Disponibles' => restaurante.mesasDisponibles > 0,
          _ => true,
        };
        return coincideTexto && coincideFiltro;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softWhite,
      appBar: AppBar(title: const Text('TableNow')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Reserva tu mesa', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Encuentra restaurantes disponibles cerca de ti.'),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _busqueda = value),
                decoration: InputDecoration(
                  hintText: 'Buscar restaurante o ubicación',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.lightGray),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                children: ['Todos', 'Disponibles'].map((filtro) {
                  return ChoiceChip(
                    label: Text(filtro),
                    selected: _filtro == filtro,
                    onSelected: (_) => setState(() => _filtro = filtro),
                    selectedColor: AppColors.goldPremium,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_cargando) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _cargarRestaurantes, child: const Text('Reintentar')),
          ],
        ),
      );
    }
    final restaurantes = _filtrados;
    if (restaurantes.isEmpty) return const Center(child: Text('No se encontraron restaurantes.'));
    return RefreshIndicator(
      onRefresh: _cargarRestaurantes,
      child: ListView.builder(
        itemCount: restaurantes.length,
        itemBuilder: (context, index) {
          final restaurante = restaurantes[index];
          return RestauranteCard(
            restaurante: restaurante,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RestauranteDetalleScreen(restaurante: restaurante)),
            ),
          );
        },
      ),
    );
  }
}
