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

  static String m1(format) => "Programado para: ${format}";

  static String m2(format) => "Enviado: ${format}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "changeLanguage":
            MessageLookupByLibrary.simpleMessage("Cambiar Idioma"),
        "changeTheme": MessageLookupByLibrary.simpleMessage("Cambiar Tema"),
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
        "homePage": MessageLookupByLibrary.simpleMessage("Página de Inicio"),
        "noBody": MessageLookupByLibrary.simpleMessage("Sin cuerpo"),
        "noDate": MessageLookupByLibrary.simpleMessage("Sin fecha"),
        "noNotifications":
            MessageLookupByLibrary.simpleMessage("Sin notificaciones"),
        "noTitle": MessageLookupByLibrary.simpleMessage("Sin título"),
        "notificationDeleted":
            MessageLookupByLibrary.simpleMessage("Notificación eliminada"),
        "notificationHistoryPage":
            MessageLookupByLibrary.simpleMessage("Historial de Notificaciones"),
        "notificationScheduled": MessageLookupByLibrary.simpleMessage(
            "Notificación programada para 1 minuto desde ahora"),
        "personalizedNotificationBody": MessageLookupByLibrary.simpleMessage(
            "Esta es una notificación personalizada de prueba"),
        "personalizedNotificationSent": MessageLookupByLibrary.simpleMessage(
            "Notificación personalizada enviada"),
        "personalizedNotificationTitle":
            MessageLookupByLibrary.simpleMessage("Notificación Personalizada"),
        "promotionalNotificationSent": MessageLookupByLibrary.simpleMessage(
            "Notificación promocional enviada"),
        "receiveNotifications":
            MessageLookupByLibrary.simpleMessage("Recibir Notificaciones"),
        "scheduleNotification":
            MessageLookupByLibrary.simpleMessage("Programar Notificación"),
        "scheduledFor": m1,
        "sendPersonalizedNotification": MessageLookupByLibrary.simpleMessage(
            "Enviar Notificación Personalizada"),
        "sendPromotionalNotification": MessageLookupByLibrary.simpleMessage(
            "Enviar Notificación Promocional"),
        "sendTestNotifications": MessageLookupByLibrary.simpleMessage(
            "Enviar Notificaciones de Prueba"),
        "sendUpdateNotification": MessageLookupByLibrary.simpleMessage(
            "Enviar Notificación de Actualización"),
        "sent": m2,
        "updateNotificationSent": MessageLookupByLibrary.simpleMessage(
            "Notificación de actualización enviada"),
        "userNotLoggedIn": MessageLookupByLibrary.simpleMessage(
            "Usuario no ha iniciado sesión. No se puede enviar la notificación."),
        "viewNotificationHistory": MessageLookupByLibrary.simpleMessage(
            "Ver Historial de Notificaciones")
      };
}
