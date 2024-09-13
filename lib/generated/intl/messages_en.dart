// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(string) => "Error: ${string}";

  static String m1(format) => "Scheduled for: ${format}";

  static String m2(format) => "Sent: ${format}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "changeLanguage":
            MessageLookupByLibrary.simpleMessage("Change Language"),
        "error": m0,
        "errorInitializingNotifications": MessageLookupByLibrary.simpleMessage(
            "Error initializing notifications. Please try again later."),
        "errorSchedulingNotification": MessageLookupByLibrary.simpleMessage(
            "Error scheduling notification. Please try again."),
        "errorSendingPersonalizedNotification":
            MessageLookupByLibrary.simpleMessage(
                "Error sending personalized notification. Please try again."),
        "errorSendingPromotionalNotification":
            MessageLookupByLibrary.simpleMessage(
                "Error sending promotional notification. Please try again."),
        "errorSendingUpdateNotification": MessageLookupByLibrary.simpleMessage(
            "Error sending update notification. Please try again."),
        "errorSigningOut": MessageLookupByLibrary.simpleMessage(
            "Error signing out. Please try again."),
        "errorUpdatingNotificationSettings":
            MessageLookupByLibrary.simpleMessage(
                "Error updating notification settings. Please try again."),
        "failedToDeleteNotification": MessageLookupByLibrary.simpleMessage(
            "Failed to delete notification"),
        "homePage": MessageLookupByLibrary.simpleMessage("Home Page"),
        "noBody": MessageLookupByLibrary.simpleMessage("No body"),
        "noDate": MessageLookupByLibrary.simpleMessage("No date"),
        "noNotifications":
            MessageLookupByLibrary.simpleMessage("No notifications"),
        "noTitle": MessageLookupByLibrary.simpleMessage("No title"),
        "notificationDeleted":
            MessageLookupByLibrary.simpleMessage("Notification deleted"),
        "notificationHistoryPage":
            MessageLookupByLibrary.simpleMessage("Notification History"),
        "notificationScheduled": MessageLookupByLibrary.simpleMessage(
            "Notification scheduled for 1 minute from now"),
        "personalizedNotificationBody": MessageLookupByLibrary.simpleMessage(
            "This is a test personalized notification"),
        "personalizedNotificationSent": MessageLookupByLibrary.simpleMessage(
            "Personalized notification sent"),
        "personalizedNotificationTitle":
            MessageLookupByLibrary.simpleMessage("Personalized Notification"),
        "promotionalNotificationSent": MessageLookupByLibrary.simpleMessage(
            "Promotional notification sent"),
        "receiveNotifications":
            MessageLookupByLibrary.simpleMessage("Receive Notifications"),
        "scheduleNotification":
            MessageLookupByLibrary.simpleMessage("Schedule Notification"),
        "scheduledFor": m1,
        "sendPersonalizedNotification": MessageLookupByLibrary.simpleMessage(
            "Send Personalized Notification"),
        "sendPromotionalNotification": MessageLookupByLibrary.simpleMessage(
            "Send Promotional Notification"),
        "sendTestNotifications":
            MessageLookupByLibrary.simpleMessage("Send Test Notifications"),
        "sendUpdateNotification":
            MessageLookupByLibrary.simpleMessage("Send Update Notification"),
        "sent": m2,
        "updateNotificationSent":
            MessageLookupByLibrary.simpleMessage("Update notification sent"),
        "userNotLoggedIn": MessageLookupByLibrary.simpleMessage(
            "User not logged in. Cannot send notification."),
        "viewNotificationHistory":
            MessageLookupByLibrary.simpleMessage("View Notification History")
      };
}
