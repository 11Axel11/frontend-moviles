import '../../../core/network/api_client.dart';
import '../models/mesa.dart';

class MesaRepository {
  MesaRepository(this._api);

  final ApiClient _api;

  Future<List<Mesa>> disponibles({
    required int restauranteId,
    required String fecha,
    required String hora,
  }) async {
    final response = await _api.get(
      '/mesas/restaurante/$restauranteId/disponibles',
      queryParameters: {'fecha': fecha, 'hora': hora},
    );
    final value = response is Map ? response['data'] : response;
    if (value is! List) return const [];
    return value
        .map((item) => Mesa.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
}
