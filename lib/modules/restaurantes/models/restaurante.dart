class Restaurante {
  final int id;
  final String nombre;
  final String ubicacion;
  final String descripcion;
  final String horario;
  final String categoria;
  final int mesasDisponibles;
  final double calificacion;
  final bool abierto;

  const Restaurante({
    required this.id,
    required this.nombre,
    required this.ubicacion,
    required this.descripcion,
    required this.horario,
    required this.categoria,
    required this.mesasDisponibles,
    required this.calificacion,
    required this.abierto,
  });
}