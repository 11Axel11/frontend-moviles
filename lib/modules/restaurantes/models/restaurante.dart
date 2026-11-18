class Restaurante {
  final int id;
  final String nombre;
  final String ubicacion;
  final String descripcion;
  final String telefono;
  final String imagenUrl;
  final bool activo;
  final int mesasDisponibles;
  final List<String> horarios;

  const Restaurante({
    required this.id,
    required this.nombre,
    required this.ubicacion,
    required this.descripcion,
    required this.telefono,
    required this.imagenUrl,
    required this.activo,
    required this.mesasDisponibles,
    required this.horarios,
  });

  factory Restaurante.fromJson(Map<String, dynamic> json) {
    final rawSchedules = json['horasDisponibles'] ?? json['horarios'];
    return Restaurante(
      id: _int(json['idRestaurante'] ?? json['id']),
      nombre: _string(json['nombre']),
      ubicacion: _string(json['ubicacion']),
      descripcion: _string(json['descripcion']),
      telefono: _string(json['telefono']),
      imagenUrl: _string(json['imagenUrl']),
      activo: json['estado'] as bool? ?? json['activo'] as bool? ?? true,
      mesasDisponibles: _int(json['mesasDisponibles']),
      horarios: rawSchedules is List
          ? rawSchedules.map(_scheduleLabel).where((value) => value.isNotEmpty).toList()
          : const [],
    );
  }

  static String _scheduleLabel(dynamic value) {
    if (value is String) return value;
    if (value is Map) {
      final open = value['horaApertura'] ?? '';
      final close = value['horaCierre'] ?? '';
      return '$open - $close';
    }
    return '';
  }

  static int _int(dynamic value) => value is num ? value.toInt() : 0;
  static String _string(dynamic value) => value?.toString() ?? '';
}
