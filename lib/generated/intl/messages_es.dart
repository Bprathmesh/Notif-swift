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

  static String m0(name) =>
      "¿Estás seguro de que quieres eliminar al usuario ${name}?";

  static String m1(string) => "Error: ${string}";

  static String m2(error) => "Error al eliminar usuario: ${error}";

  static String m3(error) => "Error al cargar los usuarios: ${error}";

  static String m4(error) =>
      "Error al actualizar el estado de administrador: ${error}";

  static String m5(error) => "Error al guardar las preferencias: ${error}";

  static String m6(name) => "Hola ${name}";

  static String m7(interest) => "${interest}";

  static String m8(name) => "${name}, ¡descubre nuestra última promoción!";

  static String m9(error) => "Registro fallido: ${error}";

  static String m10(format) => "Programado para: ${format}";

  static String m11(format) => "Enviado: ${format}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "admin": MessageLookupByLibrary.simpleMessage("Administrador"),
        "adminLogin": MessageLookupByLibrary.simpleMessage(
            "Inicio de sesión de administrador"),
        "adminPanel":
            MessageLookupByLibrary.simpleMessage("Panel de Administración"),
        "adminPassword":
            MessageLookupByLibrary.simpleMessage("Contraseña de administrador"),
        "adminPrivilegesGranted": MessageLookupByLibrary.simpleMessage(
            "Se han otorgado los privilegios de administrador"),
        "adminPrivilegesRequired": MessageLookupByLibrary.simpleMessage(
            "Se requieren privilegios de administrador para esta acción."),
        "adminStatusUpdated": MessageLookupByLibrary.simpleMessage(
            "Estado de administrador actualizado con éxito"),
        "areYouSureDeleteUser": m0,
        "becomeAdmin": MessageLookupByLibrary.simpleMessage(
            "Convertirse en Administrador"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "changeLanguage":
            MessageLookupByLibrary.simpleMessage("Cambiar Idioma"),
        "changeTheme": MessageLookupByLibrary.simpleMessage("Cambiar Tema"),
        "confirmDeletion":
            MessageLookupByLibrary.simpleMessage("Confirmar Eliminación"),
        "createAccount":
            MessageLookupByLibrary.simpleMessage("Crear una cuenta"),
        "defaultMessage": MessageLookupByLibrary.simpleMessage(
            "¡Tenemos noticias emocionantes para ti!"),
        "delete": MessageLookupByLibrary.simpleMessage("Eliminar"),
        "email": MessageLookupByLibrary.simpleMessage("Correo Electrónico"),
        "english": MessageLookupByLibrary.simpleMessage("Inglés"),
        "enterAdminPassword": MessageLookupByLibrary.simpleMessage(
            "Ingrese la Contraseña de Administrador"),
        "error": m1,
        "errorDeletingUser": m2,
        "errorFetchingNotifications": MessageLookupByLibrary.simpleMessage(
            "Error al recuperar las notificaciones. Por favor, reintente."),
        "errorInitializingNotifications": MessageLookupByLibrary.simpleMessage(
            "Error al iniciar las notificaciones. Por favor, inténtelo de nuevo más tarde."),
        "errorLoadingUser":
            MessageLookupByLibrary.simpleMessage("Error al cargar el usuario"),
        "errorLoadingUsers": m3,
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
        "errorUpdatingAdminStatus": m4,
        "errorUpdatingNotificationSettings": MessageLookupByLibrary.simpleMessage(
            "Error al actualizar la configuración de notificaciones. Por favor, inténtelo de nuevo."),
        "failedToDeleteNotification": MessageLookupByLibrary.simpleMessage(
            "Error al eliminar la notificación"),
        "failedToSavePreferences": m5,
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
        "hello": m6,
        "homePage": MessageLookupByLibrary.simpleMessage("Página de Inicio"),
        "incorrectAdminPassword": MessageLookupByLibrary.simpleMessage(
            "Contraseña de administrador incorrecta"),
        "interest": m7,
        "interests": MessageLookupByLibrary.simpleMessage("Intereses"),
        "invalidAdminPassword": MessageLookupByLibrary.simpleMessage(
            "Contraseña de administrador no válida"),
        "language": MessageLookupByLibrary.simpleMessage("Idioma"),
        "login": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
        "music": MessageLookupByLibrary.simpleMessage("Música"),
        "musicMessage1": MessageLookupByLibrary.simpleMessage(
            "¡Tu artista favorito acaba de lanzar un nuevo álbum!"),
        "musicMessage2": MessageLookupByLibrary.simpleMessage(
            "Las entradas para un próximo concierto ya están a la venta."),
        "musicMessage3": MessageLookupByLibrary.simpleMessage(
            "Descubre las listas de éxitos de esta semana."),
        "name": MessageLookupByLibrary.simpleMessage("Nombre"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noAdminPrivileges": MessageLookupByLibrary.simpleMessage(
            "No tienes privilegios de administrador."),
        "noBody": MessageLookupByLibrary.simpleMessage("Sin cuerpo"),
        "noDate": MessageLookupByLibrary.simpleMessage("Sin fecha"),
        "noNotifications":
            MessageLookupByLibrary.simpleMessage("Sin notificaciones"),
        "noTitle": MessageLookupByLibrary.simpleMessage("Sin título"),
        "noUsersFound":
            MessageLookupByLibrary.simpleMessage("No se encontraron usuarios"),
        "notificationBody":
            MessageLookupByLibrary.simpleMessage("Cuerpo de la notificación"),
        "notificationDeleted":
            MessageLookupByLibrary.simpleMessage("Notificación eliminada"),
        "notificationHistoryPage":
            MessageLookupByLibrary.simpleMessage("Historial de Notificaciones"),
        "notificationPreferencesUpdated": MessageLookupByLibrary.simpleMessage(
            "Sus preferencias de notificación han sido actualizadas."),
        "notificationScheduled": MessageLookupByLibrary.simpleMessage(
            "Notificación programada para 1 minuto desde ahora"),
        "notificationTitle":
            MessageLookupByLibrary.simpleMessage("Título de la notificación"),
        "password": MessageLookupByLibrary.simpleMessage("Contraseña"),
        "passwordMustBe6Chars": MessageLookupByLibrary.simpleMessage(
            "La contraseña debe tener al menos 6 caracteres"),
        "personalizedNotificationBody": MessageLookupByLibrary.simpleMessage(
            "Esta es una notificación personalizada de prueba"),
        "personalizedNotificationSent": MessageLookupByLibrary.simpleMessage(
            "Notificación personalizada enviada"),
        "personalizedNotificationTitle":
            MessageLookupByLibrary.simpleMessage("Notificación Personalizada"),
        "pleaseEnterBody": MessageLookupByLibrary.simpleMessage(
            "Por favor, introduce un cuerpo"),
        "pleaseEnterEmail": MessageLookupByLibrary.simpleMessage(
            "Por favor, ingrese un correo electrónico"),
        "pleaseEnterName": MessageLookupByLibrary.simpleMessage(
            "Por favor, ingrese su nombre"),
        "pleaseEnterPassword": MessageLookupByLibrary.simpleMessage(
            "Por favor, introduce la contraseña de administrador"),
        "pleaseEnterTitle": MessageLookupByLibrary.simpleMessage(
            "Por favor, introduce un título"),
        "preferences": MessageLookupByLibrary.simpleMessage("Preferencias"),
        "preferencesSaved": MessageLookupByLibrary.simpleMessage(
            "Preferencias guardadas exitosamente"),
        "preferencesUpdated":
            MessageLookupByLibrary.simpleMessage("Preferencias Actualizadas"),
        "promotionalNotificationBody": m8,
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
        "registrationFailed": m9,
        "savePreferences":
            MessageLookupByLibrary.simpleMessage("Guardar Preferencias"),
        "scheduleNewNotification": MessageLookupByLibrary.simpleMessage(
            "Programar nueva notificación"),
        "scheduleNotification":
            MessageLookupByLibrary.simpleMessage("Programar Notificación"),
        "scheduledFor": m10,
        "scheduledNotificationBody":
            MessageLookupByLibrary.simpleMessage("¡Oferta Especial!"),
        "scheduledNotificationTitle":
            MessageLookupByLibrary.simpleMessage("Notificación Programada"),
        "scheduledTime":
            MessageLookupByLibrary.simpleMessage("Hora programada"),
        "sendPersonalizedNotification": MessageLookupByLibrary.simpleMessage(
            "Enviar Notificación Personalizada"),
        "sendPromotionalNotification": MessageLookupByLibrary.simpleMessage(
            "Enviar Notificación Promocional"),
        "sendTestNotifications": MessageLookupByLibrary.simpleMessage(
            "Enviar Notificaciones de Prueba"),
        "sendUpdateNotification": MessageLookupByLibrary.simpleMessage(
            "Enviar Notificación de Actualización"),
        "sent": m11,
        "signIn": MessageLookupByLibrary.simpleMessage("Iniciar Sesión"),
        "spanish": MessageLookupByLibrary.simpleMessage("Español"),
        "sports": MessageLookupByLibrary.simpleMessage("Deportes"),
        "sportsMessage1": MessageLookupByLibrary.simpleMessage(
            "¡Alerta de gran partido! No te pierdas la acción."),
        "sportsMessage2": MessageLookupByLibrary.simpleMessage(
            "¡Tu equipo favorito tiene un próximo partido!"),
        "sportsMessage3": MessageLookupByLibrary.simpleMessage(
            "Nuevo equipo deportivo disponible."),
        "submit": MessageLookupByLibrary.simpleMessage("Enviar"),
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
        "userDeletedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Usuario eliminado con éxito"),
        "userNotLoggedIn": MessageLookupByLibrary.simpleMessage(
            "Usuario no ha iniciado sesión. No se puede enviar la notificación."),
        "viewNotificationHistory": MessageLookupByLibrary.simpleMessage(
            "Ver Historial de Notificaciones"),
        "welcomeBack":
            MessageLookupByLibrary.simpleMessage("¡Bienvenido de nuevo!"),
        "yes": MessageLookupByLibrary.simpleMessage("Sí")
      };
}
