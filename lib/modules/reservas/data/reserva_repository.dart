import '../../../core/network/api_client.dart';
import '../models/reserva.dart';

class ReservaRepository {
  ReservaRepository(this._api);

  final ApiClient _api;

  Future<Reserva> crear({
    required int restauranteId,
    required int mesaId,
    required int usuarioId,
    required String fecha,
    required String hora,
    required String horaFin,
    required int cantidadPersonas,
  }) async {
    final response = await _api.post('/reservas', body: {
      'idRestaurante': restauranteId,
      'idMesa': mesaId,
      'idUsuario': usuarioId,
      'fechaReserva': fecha,
      'horaInicio': hora,
      'horaFin': horaFin,
      'cantidadPersonas': cantidadPersonas,
    });
    return Reserva.fromJson(Map<String, dynamic>.from(response as Map));
  }

  Future<Reserva> obtener(int idReserva) async {
    final response = await _api.get('/reservas/$idReserva');
    return Reserva.fromJson(Map<String, dynamic>.from(response as Map));
  }

  Future<Reserva> cancelar(int idReserva) async {
    final response = await _api.patch('/reservas/$idReserva/cancelar');
    return Reserva.fromJson(Map<String, dynamic>.from(response as Map));
  }
}
