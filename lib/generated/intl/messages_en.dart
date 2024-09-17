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

  static String m0(name) => "Are you sure you want to delete the user ${name}?";

  static String m1(string) => "Error: ${string}";

  static String m2(error) => "Error deleting user: ${error}";

  static String m3(error) => "Error loading users: ${error}";

  static String m4(error) => "Error updating admin status: ${error}";

  static String m5(error) => "Failed to save preferences: ${error}";

  static String m6(name) => "Hello ${name}";

  static String m7(interest) => "${interest}";

  static String m8(name) => "${name}, check out our latest promotion!";

  static String m9(error) => "Registration failed: ${error}";

  static String m10(format) => "Scheduled for: ${format}";

  static String m11(format) => "Sent: ${format}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "activeUsers": MessageLookupByLibrary.simpleMessage("Active Users"),
        "admin": MessageLookupByLibrary.simpleMessage("Admin"),
        "adminLogin": MessageLookupByLibrary.simpleMessage("Admin Login"),
        "adminPanel": MessageLookupByLibrary.simpleMessage("Admin Panel"),
        "adminPassword": MessageLookupByLibrary.simpleMessage("Admin Password"),
        "adminPrivilegesGranted":
            MessageLookupByLibrary.simpleMessage("Admin privileges granted"),
        "adminPrivilegesRequired": MessageLookupByLibrary.simpleMessage(
            "Admin privileges are required for this action."),
        "adminStatusUpdated": MessageLookupByLibrary.simpleMessage(
            "Admin status updated successfully"),
        "analytics": MessageLookupByLibrary.simpleMessage("Analytics"),
        "areYouSureDeleteUser": m0,
        "becomeAdmin": MessageLookupByLibrary.simpleMessage("Become Admin"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "changeLanguage":
            MessageLookupByLibrary.simpleMessage("Change Language"),
        "changeTheme": MessageLookupByLibrary.simpleMessage("Change Theme"),
        "confirmDeletion":
            MessageLookupByLibrary.simpleMessage("Confirm Deletion"),
        "createAccount":
            MessageLookupByLibrary.simpleMessage("Create an account"),
        "defaultMessage": MessageLookupByLibrary.simpleMessage(
            "We have exciting news for you!"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "enableNotificationsMessage": MessageLookupByLibrary.simpleMessage(
            "To receive notifications, please go to settings and enable notifications."),
        "english": MessageLookupByLibrary.simpleMessage("English"),
        "enterAdminPassword":
            MessageLookupByLibrary.simpleMessage("Enter Admin Password"),
        "error": m1,
        "errorDeletingUser": m2,
        "errorFetchingNotifications": MessageLookupByLibrary.simpleMessage(
            "Error fetching notifications. Please try again."),
        "errorInitializingNotifications": MessageLookupByLibrary.simpleMessage(
            "Error initializing notifications. Please try again later."),
        "errorLoadingUser":
            MessageLookupByLibrary.simpleMessage("Error loading user"),
        "errorLoadingUsers": m3,
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
        "errorUpdatingAdminStatus": m4,
        "errorUpdatingNotificationSettings":
            MessageLookupByLibrary.simpleMessage(
                "Error updating notification settings. Please try again."),
        "failedToDeleteNotification": MessageLookupByLibrary.simpleMessage(
            "Failed to delete notification"),
        "failedToSavePreferences": m5,
        "fashion": MessageLookupByLibrary.simpleMessage("Fashion"),
        "finance": MessageLookupByLibrary.simpleMessage("Finance"),
        "food": MessageLookupByLibrary.simpleMessage("Food"),
        "foodMessage1": MessageLookupByLibrary.simpleMessage(
            "Hungry? Discover new recipes from your favorite cuisine."),
        "foodMessage2": MessageLookupByLibrary.simpleMessage(
            "Top-rated restaurants near you with special offers!"),
        "foodMessage3": MessageLookupByLibrary.simpleMessage(
            "New cooking tutorial: Learn to make gourmet dishes at home."),
        "goToSettings": MessageLookupByLibrary.simpleMessage("Go to Settings"),
        "health": MessageLookupByLibrary.simpleMessage("Health"),
        "hello": m6,
        "highActivity": MessageLookupByLibrary.simpleMessage("High Activity"),
        "homePage": MessageLookupByLibrary.simpleMessage("Home Page"),
        "incorrectAdminPassword":
            MessageLookupByLibrary.simpleMessage("Incorrect admin password"),
        "interest": m7,
        "interests": MessageLookupByLibrary.simpleMessage("Interests"),
        "invalidAdminPassword":
            MessageLookupByLibrary.simpleMessage("Invalid admin password"),
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "lowActivity": MessageLookupByLibrary.simpleMessage("Low Activity"),
        "mediumActivity":
            MessageLookupByLibrary.simpleMessage("Medium Activity"),
        "music": MessageLookupByLibrary.simpleMessage("Music"),
        "musicMessage1": MessageLookupByLibrary.simpleMessage(
            "Your favorite artist just released a new album!"),
        "musicMessage2": MessageLookupByLibrary.simpleMessage(
            "Tickets for an upcoming concert are now on sale."),
        "musicMessage3": MessageLookupByLibrary.simpleMessage(
            "Discover this week’s top hits."),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noAdminPrivileges":
            MessageLookupByLibrary.simpleMessage("No admin privileges"),
        "noBody": MessageLookupByLibrary.simpleMessage("No body"),
        "noDate": MessageLookupByLibrary.simpleMessage("No date"),
        "noNotifications":
            MessageLookupByLibrary.simpleMessage("No notifications"),
        "noSignupData":
            MessageLookupByLibrary.simpleMessage("No signup data available"),
        "noSignupsInPeriod":
            MessageLookupByLibrary.simpleMessage("No signups in this period"),
        "noTitle": MessageLookupByLibrary.simpleMessage("No title"),
        "noUsersFound": MessageLookupByLibrary.simpleMessage("No users found"),
        "notificationBody":
            MessageLookupByLibrary.simpleMessage("Notification Body"),
        "notificationDeleted":
            MessageLookupByLibrary.simpleMessage("Notification deleted"),
        "notificationHistoryPage":
            MessageLookupByLibrary.simpleMessage("Notification History"),
        "notificationPreferencesUpdated": MessageLookupByLibrary.simpleMessage(
            "Your notification preferences have been updated."),
        "notificationScheduled":
            MessageLookupByLibrary.simpleMessage("Notification scheduled "),
        "notificationSettingsUpdated": MessageLookupByLibrary.simpleMessage(
            "Notification settings updated successfully"),
        "notificationStats":
            MessageLookupByLibrary.simpleMessage("Notification Statistics"),
        "notificationTitle":
            MessageLookupByLibrary.simpleMessage("Notification Title"),
        "notificationsDisabled":
            MessageLookupByLibrary.simpleMessage("Notifications are disabled"),
        "notificationsEnabled":
            MessageLookupByLibrary.simpleMessage("Notifications are enabled"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordMustBe6Chars": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 6 characters"),
        "personalizedNotificationBody": MessageLookupByLibrary.simpleMessage(
            "This is a test personalized notification"),
        "personalizedNotificationSent": MessageLookupByLibrary.simpleMessage(
            "Personalized notification sent"),
        "personalizedNotificationTitle":
            MessageLookupByLibrary.simpleMessage("Personalized Notification"),
        "pleaseEnterBody":
            MessageLookupByLibrary.simpleMessage("Please enter a body"),
        "pleaseEnterEmail":
            MessageLookupByLibrary.simpleMessage("Please enter an email"),
        "pleaseEnterName":
            MessageLookupByLibrary.simpleMessage("Please enter your name"),
        "pleaseEnterPassword": MessageLookupByLibrary.simpleMessage(
            "Please enter the admin password"),
        "pleaseEnterTitle":
            MessageLookupByLibrary.simpleMessage("Please enter a title"),
        "preferences": MessageLookupByLibrary.simpleMessage("Preferences"),
        "preferencesSaved": MessageLookupByLibrary.simpleMessage(
            "Preferences saved successfully"),
        "preferencesUpdated":
            MessageLookupByLibrary.simpleMessage("Preferences Updated"),
        "promotionalNotificationBody": m8,
        "promotionalNotificationSent": MessageLookupByLibrary.simpleMessage(
            "Promotional notification sent"),
        "promotionalNotificationTitle":
            MessageLookupByLibrary.simpleMessage("Special Offer!"),
        "readNotifications":
            MessageLookupByLibrary.simpleMessage("Read Notifications"),
        "receiveNotifications":
            MessageLookupByLibrary.simpleMessage("Receive Notifications"),
        "receivePromotions":
            MessageLookupByLibrary.simpleMessage("Receive Promotions"),
        "receiveUpdates":
            MessageLookupByLibrary.simpleMessage("Receive Updates"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "registrationFailed": m9,
        "savePreferences":
            MessageLookupByLibrary.simpleMessage("Save Preferences"),
        "scheduleNewNotification":
            MessageLookupByLibrary.simpleMessage("Schedule New Notification"),
        "scheduleNotification":
            MessageLookupByLibrary.simpleMessage("Schedule Notification"),
        "scheduledFor": m10,
        "scheduledNotificationBody": MessageLookupByLibrary.simpleMessage(
            "This is a test scheduled notification"),
        "scheduledNotificationTitle":
            MessageLookupByLibrary.simpleMessage("Scheduled Notification"),
        "scheduledTime": MessageLookupByLibrary.simpleMessage("Scheduled Time"),
        "sendPersonalizedNotification": MessageLookupByLibrary.simpleMessage(
            "Send Personalized Notification"),
        "sendPromotionalNotification": MessageLookupByLibrary.simpleMessage(
            "Send Promotional Notification"),
        "sendTestNotifications":
            MessageLookupByLibrary.simpleMessage("Send Test Notifications"),
        "sendUpdateNotification":
            MessageLookupByLibrary.simpleMessage("Send Update Notification"),
        "sent": m11,
        "signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
        "spanish": MessageLookupByLibrary.simpleMessage("Spanish"),
        "sports": MessageLookupByLibrary.simpleMessage("Sports"),
        "sportsMessage1": MessageLookupByLibrary.simpleMessage(
            "Big match alert! Don’t miss the action."),
        "sportsMessage2": MessageLookupByLibrary.simpleMessage(
            "Your favorite team has an upcoming match!"),
        "sportsMessage3":
            MessageLookupByLibrary.simpleMessage("New sports gear available."),
        "submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "subtitle1": MessageLookupByLibrary.simpleMessage("Subtitle 1"),
        "technology": MessageLookupByLibrary.simpleMessage("Technology"),
        "technologyMessage1":
            MessageLookupByLibrary.simpleMessage("New tech gadget launched!"),
        "technologyMessage2": MessageLookupByLibrary.simpleMessage(
            "Breaking news on AI development!"),
        "technologyMessage3": MessageLookupByLibrary.simpleMessage(
            "Discover the latest in smart home technology."),
        "totalNotifications":
            MessageLookupByLibrary.simpleMessage("Total Notifications"),
        "totalUsers": MessageLookupByLibrary.simpleMessage("Total Users"),
        "travel": MessageLookupByLibrary.simpleMessage("Travel"),
        "travelMessage1": MessageLookupByLibrary.simpleMessage(
            "Dreaming of a getaway? Check out our latest travel deals!"),
        "travelMessage2": MessageLookupByLibrary.simpleMessage(
            "Explore new destinations with our travel guide."),
        "travelMessage3": MessageLookupByLibrary.simpleMessage(
            "Last-minute vacation packages available!"),
        "unreadNotifications":
            MessageLookupByLibrary.simpleMessage("Unread Notifications"),
        "updateNotificationBody": MessageLookupByLibrary.simpleMessage(
            "We have some exciting new features for you. Update now to explore!"),
        "updateNotificationSent":
            MessageLookupByLibrary.simpleMessage("Update notification sent"),
        "updateNotificationTitle":
            MessageLookupByLibrary.simpleMessage("App Update"),
        "user": MessageLookupByLibrary.simpleMessage("User"),
        "userActivityLevels":
            MessageLookupByLibrary.simpleMessage("User Activity Levels"),
        "userDeletedSuccessfully":
            MessageLookupByLibrary.simpleMessage("User deleted successfully"),
        "userInterests": MessageLookupByLibrary.simpleMessage("User Interests"),
        "userList": MessageLookupByLibrary.simpleMessage("User List"),
        "userNotLoggedIn": MessageLookupByLibrary.simpleMessage(
            "User not logged in. Cannot send notification."),
        "userPreferences":
            MessageLookupByLibrary.simpleMessage("User Preferences"),
        "userSignups": MessageLookupByLibrary.simpleMessage("User Signups"),
        "viewNotificationHistory":
            MessageLookupByLibrary.simpleMessage("View Notification History"),
        "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome Back!"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes")
      };
}
