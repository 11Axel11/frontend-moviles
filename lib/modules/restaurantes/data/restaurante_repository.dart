import '../../../core/network/api_client.dart';
import '../models/restaurante.dart';

class RestauranteRepository {
  RestauranteRepository(this._api);

  final ApiClient _api;

  Future<List<Restaurante>> listar({int page = 1, int limit = 50}) async {
    final response = await _api.get(
      '/restaurante/GetAllRestaurantesActivos',
      queryParameters: {'page': '$page', 'limit': '$limit'},
    );
    return _list(response).map(Restaurante.fromJson).toList();
  }

  Future<Restaurante> obtener(int id) async {
    final response = await _api.get('/restaurante/GetRestauranteById/$id');
    return Restaurante.fromJson(Map<String, dynamic>.from(response as Map));
  }

  List<Map<String, dynamic>> _list(dynamic response) {
    final value = response is Map ? response['data'] : response;
    if (value is! List) return const [];
    return value.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }
}
