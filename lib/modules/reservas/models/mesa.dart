enum MesaEstado { disponible, seleccionada, ocupada }

class Mesa {
  final int id;
  final int numero;
  final int cantidadSillas;
  final bool disponible;

  const Mesa({
    required this.id,
    required this.numero,
    required this.cantidadSillas,
    required this.disponible,
  });

  MesaEstado get estado => disponible ? MesaEstado.disponible : MesaEstado.ocupada;

  factory Mesa.fromJson(Map<String, dynamic> json) => Mesa(
        id: _int(json['idMesa'] ?? json['id']),
        numero: _int(json['numeroMesa'] ?? json['numero']),
        cantidadSillas: _int(json['cantidadSillas']),
        disponible: json['estado'] as bool? ?? json['disponible'] as bool? ?? true,
      );

  static int _int(dynamic value) => value is num ? value.toInt() : 0;
}
