class Usuario {
  const Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.telefono,
  });

  final int id;
  final String nombre;
  final String apellido;
  final String email;
  final String telefono;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: _int(json['idUsuario'] ?? json['id']),
        nombre: _string(json['nombre']),
        apellido: _string(json['apellido']),
        email: _string(json['email']),
        telefono: _string(json['telefono']),
      );

  static int _int(dynamic value) => value is num ? value.toInt() : 0;
  static String _string(dynamic value) => value?.toString() ?? '';
}
