# TableNow — frontend móvil

Aplicación Flutter para consultar restaurantes y registrar reservas mediante una API HTTP.

## Ejecutar

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://localhost:3000
```

Para un emulador Android usa `http://10.0.2.2:3000`. En un teléfono físico usa la IP local de la computadora que ejecuta el backend.

## Arquitectura

- `lib/core/config`: configuración por entorno.
- `lib/core/network`: cliente HTTP y errores de API.
- `lib/core/utils`: utilidades de fecha y hora.
- `lib/modules/usuarios`: modelo, repositorio y sesión de usuario.
- `lib/modules/restaurantes`: modelos, repositorio y pantallas de restaurantes.
- `lib/modules/reservas`: modelos, repositorios y flujo de reserva.

La aplicación no contiene datos mock. Los restaurantes, horarios, mesas, usuarios y reservas vienen del backend.

## Contrato del backend

```text
GET   /restaurante/GetAllRestaurantesActivos?page=1&limit=50
GET   /restaurante/GetRestauranteById/:idRestaurante
GET   /mesas/restaurante/:idRestaurante/disponibles?fecha=YYYY-MM-DD&hora=HH:mm
POST  /usuarios
GET   /usuarios/:idUsuario
POST  /reservas
GET   /reservas/:idReserva
PATCH /reservas/:idReserva/cancelar
```

La reserva usa `idUsuario`, `fechaReserva`, `horaInicio`, `horaFin` y `cantidadPersonas`. El frontend calcula `horaFin` como 30 minutos después de `horaInicio`.

El frontend crea un usuario antes de reservar y conserva su `idUsuario` en memoria durante la sesión. Todavía no se utiliza autenticación JWT.

Las respuestas paginadas usan `{ "data": [], "total": 0 }`. El restaurante debe incluir `mesasDisponibles` y `horasDisponibles`.

## Plataforma

En Android, el backend debe ser accesible desde el dispositivo o emulador y el permiso de Internet debe estar habilitado. En producción se recomienda HTTPS y configurar `API_BASE_URL` sin credenciales dentro del código.
