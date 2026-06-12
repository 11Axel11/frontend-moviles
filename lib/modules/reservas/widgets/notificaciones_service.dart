import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
  }

  static Future<void> showBookingConfirmation({
    required String restaurantName,
    required String date,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'reservations_channel', // ID del canal
      'Reservaciones', // Nombre visible
      channelDescription: 'Confirmaciones de reservas',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      0, // ID de la notificación
      '¡Reserva confirmada!',
      '$restaurantName · $date',
      details,
    );
  }
}
