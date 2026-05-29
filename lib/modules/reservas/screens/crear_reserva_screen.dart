import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../restaurantes/models/restaurante.dart';

class CrearReservaScreen extends StatefulWidget {
  final Restaurante restaurante;

  const CrearReservaScreen({
    super.key,
    required this.restaurante,
  });

  @override
  State<CrearReservaScreen> createState() => _CrearReservaScreenState();
}

class _CrearReservaScreenState extends State<CrearReservaScreen> {
  DateTime fechaSeleccionada = DateTime.now();
  int cantidadPersonas = 2;
  String horaSeleccionada = '7:00 p.m.';
  String mesaSeleccionada = 'Mesa 1';

  final List<String> horasDisponibles = [
    '12:00 p.m.',
    '1:00 p.m.',
    '2:00 p.m.',
    '6:00 p.m.',
    '7:00 p.m.',
    '8:00 p.m.',
  ];

  List<String> get mesasDisponibles {
    final cantidadMesas = widget.restaurante.mesasDisponibles;

    if (cantidadMesas <= 0) {
      return [];
    }

    return List.generate(
      cantidadMesas,
      (index) => 'Mesa ${index + 1}',
    );
  }

  Future<void> seleccionarFecha() async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.goldPremium,
              onPrimary: AppColors.blackElegant,
              surface: AppColors.softWhite,
              onSurface: AppColors.blackElegant,
            ),
          ),
          child: child!,
        );
      },
    );

    if (fecha != null && mounted) {
      setState(() {
        fechaSeleccionada = fecha;
      });
    }
  }

  String get fechaFormateada {
    return '${fechaSeleccionada.day}/${fechaSeleccionada.month}/${fechaSeleccionada.year}';
  }

  void confirmarReserva() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.softWhite,
          title: const Text(
            'Reserva confirmada',
            style: TextStyle(
              color: AppColors.blackElegant,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Tu reserva en ${widget.restaurante.nombre} fue registrada para el $fechaFormateada a las $horaSeleccionada.\n\n'
            'Personas: $cantidadPersonas\n'
            'Mesa: $mesaSeleccionada',
            style: const TextStyle(
              color: AppColors.darkGray,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cerrar',
                style: TextStyle(
                  color: AppColors.darkGray,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldPremium,
                foregroundColor: AppColors.blackElegant,
              ),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mesas = mesasDisponibles;

    return Scaffold(
      backgroundColor: AppColors.softWhite,
      appBar: AppBar(
        title: const Text(
          'Crear reserva',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RestauranteResumenCard(restaurante: widget.restaurante),

              const SizedBox(height: 24),

              const Text(
                'Detalles de la reserva',
                style: TextStyle(
                  color: AppColors.blackElegant,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Selecciona la fecha, hora, cantidad de personas y mesa.',
                style: TextStyle(
                  color: AppColors.darkGray,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 24),

              _SectionTitle(
                icon: Icons.calendar_month,
                title: 'Fecha',
              ),

              const SizedBox(height: 10),

              InkWell(
                onTap: seleccionarFecha,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.lightGray,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.date_range,
                        color: AppColors.goldPremium,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        fechaFormateada,
                        style: const TextStyle(
                          color: AppColors.blackElegant,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.darkGray,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _SectionTitle(
                icon: Icons.schedule,
                title: 'Hora disponible',
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: horasDisponibles.map((hora) {
                  final seleccionada = hora == horaSeleccionada;

                  return ChoiceChip(
                    label: Text(hora),
                    selected: seleccionada,
                    selectedColor: AppColors.goldPremium,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: seleccionada
                          ? AppColors.goldPremium
                          : AppColors.lightGray,
                    ),
                    labelStyle: TextStyle(
                      color: seleccionada
                          ? AppColors.blackElegant
                          : AppColors.darkGray,
                      fontWeight:
                          seleccionada ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (_) {
                      setState(() {
                        horaSeleccionada = hora;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              _SectionTitle(
                icon: Icons.people,
                title: 'Cantidad de personas',
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.lightGray,
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Personas',
                      style: TextStyle(
                        color: AppColors.blackElegant,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: cantidadPersonas > 1
                          ? () {
                              setState(() {
                                cantidadPersonas--;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                      color: AppColors.goldPremium,
                    ),
                    Text(
                      cantidadPersonas.toString(),
                      style: const TextStyle(
                        color: AppColors.blackElegant,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: cantidadPersonas < 10
                          ? () {
                              setState(() {
                                cantidadPersonas++;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.add_circle_outline),
                      color: AppColors.goldPremium,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _SectionTitle(
                icon: Icons.table_restaurant,
                title: 'Mesa',
              ),

              const SizedBox(height: 10),

              if (mesas.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.lightGray,
                    ),
                  ),
                  child: const Text(
                    'No hay mesas disponibles para este restaurante.',
                    style: TextStyle(
                      color: AppColors.darkGray,
                      fontSize: 14,
                    ),
                  ),
                )
              else
                DropdownButtonFormField<String>(
                  initialValue: mesaSeleccionada,
                  decoration: InputDecoration(
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
                  items: mesas.map((mesa) {
                    return DropdownMenuItem<String>(
                      value: mesa,
                      child: Text(mesa),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      mesaSeleccionada = value;
                    });
                  },
                ),

              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.blackElegant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumen',
                      style: TextStyle(
                        color: AppColors.softWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _ResumenItem(
                      label: 'Restaurante',
                      value: widget.restaurante.nombre,
                    ),
                    _ResumenItem(
                      label: 'Fecha',
                      value: fechaFormateada,
                    ),
                    _ResumenItem(
                      label: 'Hora',
                      value: horaSeleccionada,
                    ),
                    _ResumenItem(
                      label: 'Personas',
                      value: cantidadPersonas.toString(),
                    ),
                    _ResumenItem(
                      label: 'Mesa',
                      value: mesas.isEmpty ? 'No disponible' : mesaSeleccionada,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: mesas.isEmpty ? null : confirmarReserva,
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
                    'Confirmar reserva',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _RestauranteResumenCard extends StatelessWidget {
  final Restaurante restaurante;

  const _RestauranteResumenCard({
    required this.restaurante,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.blackElegant,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.goldPremium,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.restaurant,
              color: AppColors.blackElegant,
              size: 34,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurante.nombre,
                  style: const TextStyle(
                    color: AppColors.softWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  restaurante.ubicacion,
                  style: const TextStyle(
                    color: AppColors.lightGray,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  restaurante.horario,
                  style: const TextStyle(
                    color: AppColors.goldPremium,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.goldPremium,
          size: 22,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.blackElegant,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ResumenItem extends StatelessWidget {
  final String label;
  final String value;

  const _ResumenItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: AppColors.lightGray,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.softWhite,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}