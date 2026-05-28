import '../models/restaurante.dart';

const List<Restaurante> restaurantesMock = [
  Restaurante(
    id: 1,
    nombre: 'La Terraza Dorada',
    ubicacion: 'Nicoya centro',
    descripcion: 'Restaurante familiar con ambiente elegante y comida variada.',
    horario: '11:00 a.m. - 10:00 p.m.',
    categoria: 'Familiar',
    mesasDisponibles: 5,
    calificacion: 4.8,
    abierto: true,
  ),
  Restaurante(
    id: 2,
    nombre: 'Sabor Guanacasteco',
    ubicacion: 'Santa Cruz',
    descripcion: 'Comida típica costarricense con un ambiente acogedor.',
    horario: '10:00 a.m. - 9:00 p.m.',
    categoria: 'Típico',
    mesasDisponibles: 3,
    calificacion: 4.6,
    abierto: true,
  ),
  Restaurante(
    id: 3,
    nombre: 'Noche Urbana',
    ubicacion: 'Liberia',
    descripcion: 'Restaurante moderno ideal para cenas y reuniones.',
    horario: '4:00 p.m. - 11:00 p.m.',
    categoria: 'Moderno',
    mesasDisponibles: 0,
    calificacion: 4.4,
    abierto: false,
  ),
];