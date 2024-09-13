// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  static String m0(string) => "Error: ${string}";

  static String m1(error) => "Error al guardar las preferencias: ${error}";

  static String m2(name) => "Hola ${name}";

  static String m3(interest) => "${interest}";

  static String m4(name) => "${name}, ¡descubre nuestra última promoción!";

  static String m5(error) => "Registro fallido: ${error}";

  static String m6(format) => "Programado para: ${format}";

  static String m7(format) => "Enviado: ${format}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "changeLanguage":
            MessageLookupByLibrary.simpleMessage("Cambiar Idioma"),
        "changeTheme": MessageLookupByLibrary.simpleMessage("Cambiar Tema"),
        "createAccount":
            MessageLookupByLibrary.simpleMessage("Crear una cuenta"),
        "defaultMessage": MessageLookupByLibrary.simpleMessage(
            "¡Tenemos noticias emocionantes para ti!"),
        "email": MessageLookupByLibrary.simpleMessage("Correo Electrónico"),
        "english": MessageLookupByLibrary.simpleMessage("Inglés"),
        "error": m0,
        "errorInitializingNotifications": MessageLookupByLibrary.simpleMessage(
            "Error al iniciar las notificaciones. Por favor, inténtelo de nuevo más tarde."),
        "errorSchedulingNotification": MessageLookupByLibrary.simpleMessage(
            "Error al programar la notificación. Por favor, inténtelo de nuevo."),
        "errorSendingPersonalizedNotification":
            MessageLookupByLibrary.simpleMessage(
                "Error al enviar la notificación personalizada. Por favor, inténtelo de nuevo."),
        "errorSendingPromotionalNotification": MessageLookupByLibrary.simpleMessage(
            "Error al enviar la notificación promocional. Por favor, inténtelo de nuevo."),
        "errorSendingUpdateNotification": MessageLookupByLibrary.simpleMessage(
            "Error al enviar la notificación de actualización. Por favor, inténtelo de nuevo."),
        "errorSigningOut": MessageLookupByLibrary.simpleMessage(
            "Error al cerrar sesión. Por favor, inténtelo de nuevo."),
        "errorUpdatingNotificationSettings": MessageLookupByLibrary.simpleMessage(
            "Error al actualizar la configuración de notificaciones. Por favor, inténtelo de nuevo."),
        "failedToDeleteNotification": MessageLookupByLibrary.simpleMessage(
            "Error al eliminar la notificación"),
        "failedToSavePreferences": m1,
        "fashion": MessageLookupByLibrary.simpleMessage("Moda"),
        "finance": MessageLookupByLibrary.simpleMessage("Finanzas"),
        "food": MessageLookupByLibrary.simpleMessage("Comida"),
        "foodMessage1": MessageLookupByLibrary.simpleMessage(
            "¿Hambre? Descubre nuevas recetas de tu cocina favorita."),
        "foodMessage2": MessageLookupByLibrary.simpleMessage(
            "¡Restaurantes mejor valorados en tu zona con ofertas especiales!"),
        "foodMessage3": MessageLookupByLibrary.simpleMessage(
            "Nuevo tutorial de cocina: Aprende a hacer platos gourmet en casa."),
        "health": MessageLookupByLibrary.simpleMessage("Salud"),
        "hello": m2,
        "homePage": MessageLookupByLibrary.simpleMessage("Página de Inicio"),
        "interest": m3,
        "interests": MessageLookupByLibrary.simpleMessage("Intereses"),
        "language": MessageLookupByLibrary.simpleMessage("Idioma"),
        "music": MessageLookupByLibrary.simpleMessage("Música"),
        "musicMessage1": MessageLookupByLibrary.simpleMessage(
            "¡Tu artista favorito acaba de lanzar un nuevo álbum!"),
        "musicMessage2": MessageLookupByLibrary.simpleMessage(
            "Las entradas para un próximo concierto ya están a la venta."),
        "musicMessage3": MessageLookupByLibrary.simpleMessage(
            "Descubre las listas de éxitos de esta semana."),
        "name": MessageLookupByLibrary.simpleMessage("Nombre"),
        "noBody": MessageLookupByLibrary.simpleMessage("Sin cuerpo"),
        "noDate": MessageLookupByLibrary.simpleMessage("Sin fecha"),
        "noNotifications":
            MessageLookupByLibrary.simpleMessage("Sin notificaciones"),
        "noTitle": MessageLookupByLibrary.simpleMessage("Sin título"),
        "notificationDeleted":
            MessageLookupByLibrary.simpleMessage("Notificación eliminada"),
        "notificationHistoryPage":
            MessageLookupByLibrary.simpleMessage("Historial de Notificaciones"),
        "notificationPreferencesUpdated": MessageLookupByLibrary.simpleMessage(
            "Sus preferencias de notificación han sido actualizadas."),
        "notificationScheduled": MessageLookupByLibrary.simpleMessage(
            "Notificación programada para 1 minuto desde ahora"),
        "password": MessageLookupByLibrary.simpleMessage("Contraseña"),
        "passwordMustBe6Chars": MessageLookupByLibrary.simpleMessage(
            "La contraseña debe tener al menos 6 caracteres"),
        "personalizedNotificationBody": MessageLookupByLibrary.simpleMessage(
            "Esta es una notificación personalizada de prueba"),
        "personalizedNotificationSent": MessageLookupByLibrary.simpleMessage(
            "Notificación personalizada enviada"),
        "personalizedNotificationTitle":
            MessageLookupByLibrary.simpleMessage("Notificación Personalizada"),
        "pleaseEnterEmail": MessageLookupByLibrary.simpleMessage(
            "Por favor, ingrese un correo electrónico"),
        "pleaseEnterName": MessageLookupByLibrary.simpleMessage(
            "Por favor, ingrese su nombre"),
        "preferences": MessageLookupByLibrary.simpleMessage("Preferencias"),
        "preferencesSaved": MessageLookupByLibrary.simpleMessage(
            "Preferencias guardadas exitosamente"),
        "preferencesUpdated":
            MessageLookupByLibrary.simpleMessage("Preferencias Actualizadas"),
        "promotionalNotificationBody": m4,
        "promotionalNotificationSent": MessageLookupByLibrary.simpleMessage(
            "Notificación promocional enviada"),
        "promotionalNotificationTitle":
            MessageLookupByLibrary.simpleMessage("¡Oferta Especial!"),
        "receiveNotifications":
            MessageLookupByLibrary.simpleMessage("Recibir Notificaciones"),
        "receivePromotions":
            MessageLookupByLibrary.simpleMessage("Recibir Promociones"),
        "receiveUpdates":
            MessageLookupByLibrary.simpleMessage("Recibir Actualizaciones"),
        "register": MessageLookupByLibrary.simpleMessage("Registrarse"),
        "registrationFailed": m5,
        "savePreferences":
            MessageLookupByLibrary.simpleMessage("Guardar Preferencias"),
        "scheduleNotification":
            MessageLookupByLibrary.simpleMessage("Programar Notificación"),
        "scheduledFor": m6,
        "scheduledNotificationTitle":
            MessageLookupByLibrary.simpleMessage("Notificación Programada"),
        "sendPersonalizedNotification": MessageLookupByLibrary.simpleMessage(
            "Enviar Notificación Personalizada"),
        "sendPromotionalNotification": MessageLookupByLibrary.simpleMessage(
            "Enviar Notificación Promocional"),
        "sendTestNotifications": MessageLookupByLibrary.simpleMessage(
            "Enviar Notificaciones de Prueba"),
        "sendUpdateNotification": MessageLookupByLibrary.simpleMessage(
            "Enviar Notificación de Actualización"),
        "sent": m7,
        "signIn": MessageLookupByLibrary.simpleMessage("Iniciar Sesión"),
        "spanish": MessageLookupByLibrary.simpleMessage("Español"),
        "sports": MessageLookupByLibrary.simpleMessage("Deportes"),
        "sportsMessage1": MessageLookupByLibrary.simpleMessage(
            "¡Alerta de gran partido! No te pierdas la acción."),
        "sportsMessage2": MessageLookupByLibrary.simpleMessage(
            "¡Tu equipo favorito tiene un próximo partido!"),
        "sportsMessage3": MessageLookupByLibrary.simpleMessage(
            "Nuevo equipo deportivo disponible."),
        "technology": MessageLookupByLibrary.simpleMessage("Tecnología"),
        "technologyMessage1": MessageLookupByLibrary.simpleMessage(
            "¡Nuevo gadget tecnológico lanzado!"),
        "technologyMessage2": MessageLookupByLibrary.simpleMessage(
            "¡Noticias de última hora en el desarrollo de IA!"),
        "technologyMessage3": MessageLookupByLibrary.simpleMessage(
            "Descubre lo último en tecnología para el hogar inteligente."),
        "travel": MessageLookupByLibrary.simpleMessage("Viajes"),
        "travelMessage1": MessageLookupByLibrary.simpleMessage(
            "¿Soñando con una escapada? ¡Mira nuestras últimas ofertas de viaje!"),
        "travelMessage2": MessageLookupByLibrary.simpleMessage(
            "Explora nuevos destinos con nuestra guía de viaje."),
        "travelMessage3": MessageLookupByLibrary.simpleMessage(
            "¡Paquetes de vacaciones de última hora disponibles!"),
        "updateNotificationBody": MessageLookupByLibrary.simpleMessage(
            "Tenemos nuevas funciones emocionantes para ti. ¡Actualiza ahora para explorarlas!"),
        "updateNotificationSent": MessageLookupByLibrary.simpleMessage(
            "Notificación de actualización enviada"),
        "updateNotificationTitle":
            MessageLookupByLibrary.simpleMessage("Actualización de la App"),
        "user": MessageLookupByLibrary.simpleMessage("Usuario"),
        "userNotLoggedIn": MessageLookupByLibrary.simpleMessage(
            "Usuario no ha iniciado sesión. No se puede enviar la notificación."),
        "viewNotificationHistory": MessageLookupByLibrary.simpleMessage(
            "Ver Historial de Notificaciones"),
        "welcomeBack":
            MessageLookupByLibrary.simpleMessage("¡Bienvenido de nuevo!")
      };
}
