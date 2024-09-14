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

  static String m1(error) => "Failed to save preferences: ${error}";

  static String m2(name) => "Hello ${name}";

  static String m3(interest) => "${interest}";

  static String m4(name) => "${name}, check out our latest promotion!";

  static String m5(error) => "Registration failed: ${error}";

  static String m6(format) => "Scheduled for: ${format}";

  static String m7(format) => "Sent: ${format}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "changeLanguage":
            MessageLookupByLibrary.simpleMessage("Change Language"),
        "changeTheme": MessageLookupByLibrary.simpleMessage("Change Theme"),
        "createAccount":
            MessageLookupByLibrary.simpleMessage("Create an account"),
        "defaultMessage": MessageLookupByLibrary.simpleMessage(
            "We have exciting news for you!"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "english": MessageLookupByLibrary.simpleMessage("English"),
        "error": m0,
        "errorFetchingNotifications": MessageLookupByLibrary.simpleMessage(
            "Error fetching notifications. Please try again."),
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
        "failedToSavePreferences": m1,
        "fashion": MessageLookupByLibrary.simpleMessage("Fashion"),
        "finance": MessageLookupByLibrary.simpleMessage("Finance"),
        "food": MessageLookupByLibrary.simpleMessage("Food"),
        "foodMessage1": MessageLookupByLibrary.simpleMessage(
            "Hungry? Discover new recipes from your favorite cuisine."),
        "foodMessage2": MessageLookupByLibrary.simpleMessage(
            "Top-rated restaurants near you with special offers!"),
        "foodMessage3": MessageLookupByLibrary.simpleMessage(
            "New cooking tutorial: Learn to make gourmet dishes at home."),
        "health": MessageLookupByLibrary.simpleMessage("Health"),
        "hello": m2,
        "homePage": MessageLookupByLibrary.simpleMessage("Home Page"),
        "interest": m3,
        "interests": MessageLookupByLibrary.simpleMessage("Interests"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "music": MessageLookupByLibrary.simpleMessage("Music"),
        "musicMessage1": MessageLookupByLibrary.simpleMessage(
            "Your favorite artist just released a new album!"),
        "musicMessage2": MessageLookupByLibrary.simpleMessage(
            "Tickets for an upcoming concert are now on sale."),
        "musicMessage3": MessageLookupByLibrary.simpleMessage(
            "Discover this week’s top hits."),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "noBody": MessageLookupByLibrary.simpleMessage("No body"),
        "noDate": MessageLookupByLibrary.simpleMessage("No date"),
        "noNotifications":
            MessageLookupByLibrary.simpleMessage("No notifications"),
        "noTitle": MessageLookupByLibrary.simpleMessage("No title"),
        "notificationDeleted":
            MessageLookupByLibrary.simpleMessage("Notification deleted"),
        "notificationHistoryPage":
            MessageLookupByLibrary.simpleMessage("Notification History"),
        "notificationPreferencesUpdated": MessageLookupByLibrary.simpleMessage(
            "Your notification preferences have been updated."),
        "notificationScheduled": MessageLookupByLibrary.simpleMessage(
            "Notification scheduled for 1 minute from now"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordMustBe6Chars": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 6 characters"),
        "personalizedNotificationBody": MessageLookupByLibrary.simpleMessage(
            "This is a test personalized notification"),
        "personalizedNotificationSent": MessageLookupByLibrary.simpleMessage(
            "Personalized notification sent"),
        "personalizedNotificationTitle":
            MessageLookupByLibrary.simpleMessage("Personalized Notification"),
        "pleaseEnterEmail":
            MessageLookupByLibrary.simpleMessage("Please enter an email"),
        "pleaseEnterName":
            MessageLookupByLibrary.simpleMessage("Please enter your name"),
        "preferences": MessageLookupByLibrary.simpleMessage("Preferences"),
        "preferencesSaved": MessageLookupByLibrary.simpleMessage(
            "Preferences saved successfully"),
        "preferencesUpdated":
            MessageLookupByLibrary.simpleMessage("Preferences Updated"),
        "promotionalNotificationBody": m4,
        "promotionalNotificationSent": MessageLookupByLibrary.simpleMessage(
            "Promotional notification sent"),
        "promotionalNotificationTitle":
            MessageLookupByLibrary.simpleMessage("Special Offer!"),
        "receiveNotifications":
            MessageLookupByLibrary.simpleMessage("Receive Notifications"),
        "receivePromotions":
            MessageLookupByLibrary.simpleMessage("Receive Promotions"),
        "receiveUpdates":
            MessageLookupByLibrary.simpleMessage("Receive Updates"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "registrationFailed": m5,
        "savePreferences":
            MessageLookupByLibrary.simpleMessage("Save Preferences"),
        "scheduleNotification":
            MessageLookupByLibrary.simpleMessage("Schedule Notification"),
        "scheduledFor": m6,
        "scheduledNotificationBody": MessageLookupByLibrary.simpleMessage(
            "This is a test scheduled notification"),
        "scheduledNotificationTitle":
            MessageLookupByLibrary.simpleMessage("Scheduled Notification"),
        "sendPersonalizedNotification": MessageLookupByLibrary.simpleMessage(
            "Send Personalized Notification"),
        "sendPromotionalNotification": MessageLookupByLibrary.simpleMessage(
            "Send Promotional Notification"),
        "sendTestNotifications":
            MessageLookupByLibrary.simpleMessage("Send Test Notifications"),
        "sendUpdateNotification":
            MessageLookupByLibrary.simpleMessage("Send Update Notification"),
        "sent": m7,
        "signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
        "spanish": MessageLookupByLibrary.simpleMessage("Spanish"),
        "sports": MessageLookupByLibrary.simpleMessage("Sports"),
        "sportsMessage1": MessageLookupByLibrary.simpleMessage(
            "Big match alert! Don’t miss the action."),
        "sportsMessage2": MessageLookupByLibrary.simpleMessage(
            "Your favorite team has an upcoming match!"),
        "sportsMessage3":
            MessageLookupByLibrary.simpleMessage("New sports gear available."),
        "technology": MessageLookupByLibrary.simpleMessage("Technology"),
        "technologyMessage1":
            MessageLookupByLibrary.simpleMessage("New tech gadget launched!"),
        "technologyMessage2": MessageLookupByLibrary.simpleMessage(
            "Breaking news on AI development!"),
        "technologyMessage3": MessageLookupByLibrary.simpleMessage(
            "Discover the latest in smart home technology."),
        "travel": MessageLookupByLibrary.simpleMessage("Travel"),
        "travelMessage1": MessageLookupByLibrary.simpleMessage(
            "Dreaming of a getaway? Check out our latest travel deals!"),
        "travelMessage2": MessageLookupByLibrary.simpleMessage(
            "Explore new destinations with our travel guide."),
        "travelMessage3": MessageLookupByLibrary.simpleMessage(
            "Last-minute vacation packages available!"),
        "updateNotificationBody": MessageLookupByLibrary.simpleMessage(
            "We have some exciting new features for you. Update now to explore!"),
        "updateNotificationSent":
            MessageLookupByLibrary.simpleMessage("Update notification sent"),
        "updateNotificationTitle":
            MessageLookupByLibrary.simpleMessage("App Update"),
        "user": MessageLookupByLibrary.simpleMessage("User"),
        "userNotLoggedIn": MessageLookupByLibrary.simpleMessage(
            "User not logged in. Cannot send notification."),
        "viewNotificationHistory":
            MessageLookupByLibrary.simpleMessage("View Notification History"),
        "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome Back!")
      };
}
