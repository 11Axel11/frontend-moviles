import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/restaurantes_mock_data.dart';
import '../models/restaurante.dart';
import '../widgets/restaurante_card.dart';

class RestaurantesScreen extends StatefulWidget {
  const RestaurantesScreen({super.key});

  @override
  State<RestaurantesScreen> createState() => _RestaurantesScreenState();
}

class _RestaurantesScreenState extends State<RestaurantesScreen> {
  String filtroSeleccionado = 'Todos';
  String busqueda = '';

  List<Restaurante> get restaurantesFiltrados {
    return restaurantesMock.where((restaurante) {
      final coincideBusqueda = restaurante.nombre
              .toLowerCase()
              .contains(busqueda.toLowerCase()) ||
          restaurante.ubicacion.toLowerCase().contains(busqueda.toLowerCase());

      final coincideFiltro = switch (filtroSeleccionado) {
        'Abiertos' => restaurante.abierto,
        'Disponibles' => restaurante.mesasDisponibles > 0,
        _ => true,
      };

      return coincideBusqueda && coincideFiltro;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantes = restaurantesFiltrados;

    return Scaffold(
      backgroundColor: AppColors.softWhite,
      appBar: AppBar(
        title: const Text(
          'TableNow',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reserva tu mesa',
                style: TextStyle(
                  color: AppColors.blackElegant,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Encuentra restaurantes disponibles cerca de ti.',
                style: TextStyle(
                  color: AppColors.darkGray,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                onChanged: (value) {
                  setState(() {
                    busqueda = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Buscar restaurante o ubicación',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.darkGray,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.lightGray,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.goldPremium,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FiltroChip(
                      label: 'Todos',
                      seleccionado: filtroSeleccionado == 'Todos',
                      onTap: () {
                        setState(() {
                          filtroSeleccionado = 'Todos';
                        });
                      },
                    ),
                    _FiltroChip(
                      label: 'Abiertos',
                      seleccionado: filtroSeleccionado == 'Abiertos',
                      onTap: () {
                        setState(() {
                          filtroSeleccionado = 'Abiertos';
                        });
                      },
                    ),
                    _FiltroChip(
                      label: 'Disponibles',
                      seleccionado: filtroSeleccionado == 'Disponibles',
                      onTap: () {
                        setState(() {
                          filtroSeleccionado = 'Disponibles';
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: restaurantes.isEmpty
                    ? const Center(
                        child: Text(
                          'No se encontraron restaurantes.',
                          style: TextStyle(
                            color: AppColors.darkGray,
                            fontSize: 15,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: restaurantes.length,
                        itemBuilder: (context, index) {
                          final restaurante = restaurantes[index];

                          return RestauranteCard(
                            restaurante: restaurante,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Seleccionaste ${restaurante.nombre}',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FiltroChip extends StatelessWidget {
  final String label;
  final bool seleccionado;
  final VoidCallback onTap;

  const _FiltroChip({
    required this.label,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: seleccionado,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.goldPremium,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: seleccionado ? AppColors.blackElegant : AppColors.darkGray,
          fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(
          color: seleccionado ? AppColors.goldPremium : AppColors.lightGray,
        ),
      ),
    );
  }
}