import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../restaurantes/models/restaurante.dart';
import '../models/mesa.dart';
import '../widgets/mesas_grid.dart';
import '../widgets/horario_selector.dart';
import '../widgets/personas_selector.dart';
import '../widgets/continuar_button.dart';
import 'reserva_confirmacion_screen.dart';

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
  String horaSeleccionada = '7:00 PM';
  int? mesaSeleccionada;
  List<Mesa> mesas = [];

  final List<String> horasDisponibles = [
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
    '7:30 PM',
    '8:00 PM',
    '8:30 PM',
  ];

  @override
  void initState() {
    super.initState();
    _generarMesas();
  }

  void _generarMesas() {
    mesas = List.generate(
      9,
      (index) {
        final numero = index + 1;
        if (numero <= widget.restaurante.mesasDisponibles) {
          return Mesa(numero: numero, estado: MesaEstado.disponible);
        } else {
          return Mesa(numero: numero, estado: MesaEstado.ocupada);
        }
      },
    );
  }

  void _seleccionarMesa(int numero) {
    setState(() {
      mesaSeleccionada = numero;
      mesas = mesas.map((mesa) {
        if (mesa.numero == numero) {
          return mesa.copyWith(estado: MesaEstado.seleccionada);
        } else if (mesa.estado == MesaEstado.seleccionada) {
          return mesa.copyWith(estado: MesaEstado.disponible);
        }
        return mesa;
      }).toList();
    });
  }

  bool get formularioCompleto {
    return mesaSeleccionada != null;
  }

  void confirmarReserva() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservaConfirmacionScreen(
          restaurante: widget.restaurante,
          fecha: '${fechaSeleccionada.day} ${_getMonthName(fechaSeleccionada.month)}, ${fechaSeleccionada.year}',
          hora: horaSeleccionada,
          mesa: mesaSeleccionada!,
          personas: cantidadPersonas,
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackElegant,
      appBar: AppBar(
        backgroundColor: AppColors.blackElegant,
        foregroundColor: AppColors.softWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text(
              'Selecciona Mesa y Horario',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.restaurante.nombre,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MesasGrid(
                mesas: mesas,
                onMesaSeleccionada: _seleccionarMesa,
              ),
              const SizedBox(height: 32),
              HorarioSelector(
                horasDisponibles: horasDisponibles,
                horaSeleccionada: horaSeleccionada,
                onHoraChanged: (hora) {
                  setState(() {
                    horaSeleccionada = hora;
                  });
                },
              ),
              const SizedBox(height: 32),
              PersonasSelector(
                cantidadPersonas: cantidadPersonas,
                onCantidadChanged: (cantidad) {
                  setState(() {
                    cantidadPersonas = cantidad;
                  });
                },
              ),
              const SizedBox(height: 32),
              ContinuarButton(
                habilitado: formularioCompleto,
                onPressed: confirmarReserva,
              ),
            ],
          ),
        ),
      ),
    );
  }
}