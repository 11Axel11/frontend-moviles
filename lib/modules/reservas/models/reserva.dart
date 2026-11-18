class Reserva {
  final int id;
  final int restauranteId;
  final int mesaId;
  final int? usuarioId;
  final String restauranteNombre;
  final String fechaReserva;
  final String horaInicio;
  final String horaFin;
  final int personas;
  final String estado;

  const Reserva({
    required this.id,
    required this.restauranteId,
    required this.mesaId,
    required this.usuarioId,
    required this.restauranteNombre,
    required this.fechaReserva,
    required this.horaInicio,
    required this.horaFin,
    required this.personas,
    required this.estado,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    final restaurante = _map(json['restaurante']);
    final mesa = _map(json['mesa']);
    final usuario = _map(json['usuario']);
    return Reserva(
      id: _int(json['idReserva'] ?? json['id']),
      restauranteId: _int(json['idRestaurante'] ?? restaurante['idRestaurante']),
      mesaId: _int(json['idMesa'] ?? mesa['idMesa']),
      usuarioId: _nullableInt(json['idUsuario'] ?? usuario['idUsuario']),
      restauranteNombre: (json['restauranteNombre'] ?? restaurante['nombre'] ?? '').toString(),
      fechaReserva: (json['fechaReserva'] ?? json['fecha'] ?? '').toString(),
      horaInicio: (json['horaInicio'] ?? json['hora'] ?? '').toString(),
      horaFin: (json['horaFin'] ?? '').toString(),
      personas: _int(json['cantidadPersonas'] ?? json['personas']),
      estado: (json['estado'] ?? 'confirmada').toString(),
    );
  }

  static int _int(dynamic value) => value is num ? value.toInt() : 0;
  static int? _nullableInt(dynamic value) => value is num ? value.toInt() : null;
  static Map<String, dynamic> _map(dynamic value) => value is Map ? Map<String, dynamic>.from(value) : const {};
}
