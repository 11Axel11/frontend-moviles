import '../models/usuario.dart';

class UsuarioSession {
  UsuarioSession._();

  static Usuario? current;

  static void set(Usuario usuario) => current = usuario;
  static void clear() => current = null;
}
