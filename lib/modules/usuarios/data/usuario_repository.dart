import '../../../core/network/api_client.dart';
import '../models/usuario.dart';

class UsuarioRepository {
  UsuarioRepository(this._api);

  final ApiClient _api;

  Future<Usuario> crear({
    required String nombre,
    required String apellido,
    required String email,
    required String telefono,
  }) async {
    final response = await _api.post('/usuarios', body: {
      'nombre': nombre.trim(),
      'apellido': apellido.trim(),
      'email': email.trim().toLowerCase(),
      'telefono': telefono.trim(),
    });
    return Usuario.fromJson(Map<String, dynamic>.from(response as Map));
  }

  Future<Usuario> obtener(int idUsuario) async {
    final response = await _api.get('/usuarios/$idUsuario');
    return Usuario.fromJson(Map<String, dynamic>.from(response as Map));
  }
}
