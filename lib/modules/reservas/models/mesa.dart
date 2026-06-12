enum MesaEstado {
  disponible,
  seleccionada,
  ocupada,
}

class Mesa {
  final int numero;
  final MesaEstado estado;

  Mesa({
    required this.numero,
    required this.estado,
  });

  Mesa copyWith({
    int? numero,
    MesaEstado? estado,
  }) {
    return Mesa(
      numero: numero ?? this.numero,
      estado: estado ?? this.estado,
    );
  }
}
