// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Home Page`
  String get homePage {
    return Intl.message(
      'Home Page',
      name: 'homePage',
      desc: '',
      args: [],
    );
  }

  /// `Receive Notifications`
  String get receiveNotifications {
    return Intl.message(
      'Receive Notifications',
      name: 'receiveNotifications',
      desc: '',
      args: [],
    );
  }

  /// `View Notification History`
  String get viewNotificationHistory {
    return Intl.message(
      'View Notification History',
      name: 'viewNotificationHistory',
      desc: '',
      args: [],
    );
  }

  /// `Send Test Notifications`
  String get sendTestNotifications {
    return Intl.message(
      'Send Test Notifications',
      name: 'sendTestNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Send Personalized Notification`
  String get sendPersonalizedNotification {
    return Intl.message(
      'Send Personalized Notification',
      name: 'sendPersonalizedNotification',
      desc: '',
      args: [],
    );
  }

  /// `Send Promotional Notification`
  String get sendPromotionalNotification {
    return Intl.message(
      'Send Promotional Notification',
      name: 'sendPromotionalNotification',
      desc: '',
      args: [],
    );
  }

  /// `Send Update Notification`
  String get sendUpdateNotification {
    return Intl.message(
      'Send Update Notification',
      name: 'sendUpdateNotification',
      desc: '',
      args: [],
    );
  }

  /// `Schedule Notification`
  String get scheduleNotification {
    return Intl.message(
      'Schedule Notification',
      name: 'scheduleNotification',
      desc: '',
      args: [],
    );
  }

  /// `Error initializing notifications. Please try again later.`
  String get errorInitializingNotifications {
    return Intl.message(
      'Error initializing notifications. Please try again later.',
      name: 'errorInitializingNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Error updating notification settings. Please try again.`
  String get errorUpdatingNotificationSettings {
    return Intl.message(
      'Error updating notification settings. Please try again.',
      name: 'errorUpdatingNotificationSettings',
      desc: '',
      args: [],
    );
  }

  /// `Error signing out. Please try again.`
  String get errorSigningOut {
    return Intl.message(
      'Error signing out. Please try again.',
      name: 'errorSigningOut',
      desc: '',
      args: [],
    );
  }

  /// `Personalized Notification`
  String get personalizedNotificationTitle {
    return Intl.message(
      'Personalized Notification',
      name: 'personalizedNotificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `This is a test personalized notification`
  String get personalizedNotificationBody {
    return Intl.message(
      'This is a test personalized notification',
      name: 'personalizedNotificationBody',
      desc: '',
      args: [],
    );
  }

  /// `Personalized notification sent`
  String get personalizedNotificationSent {
    return Intl.message(
      'Personalized notification sent',
      name: 'personalizedNotificationSent',
      desc: '',
      args: [],
    );
  }

  /// `User not logged in. Cannot send notification.`
  String get userNotLoggedIn {
    return Intl.message(
      'User not logged in. Cannot send notification.',
      name: 'userNotLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `Error sending personalized notification. Please try again.`
  String get errorSendingPersonalizedNotification {
    return Intl.message(
      'Error sending personalized notification. Please try again.',
      name: 'errorSendingPersonalizedNotification',
      desc: '',
      args: [],
    );
  }

  /// `Promotional notification sent`
  String get promotionalNotificationSent {
    return Intl.message(
      'Promotional notification sent',
      name: 'promotionalNotificationSent',
      desc: '',
      args: [],
    );
  }

  /// `Error sending promotional notification. Please try again.`
  String get errorSendingPromotionalNotification {
    return Intl.message(
      'Error sending promotional notification. Please try again.',
      name: 'errorSendingPromotionalNotification',
      desc: '',
      args: [],
    );
  }

  /// `Update notification sent`
  String get updateNotificationSent {
    return Intl.message(
      'Update notification sent',
      name: 'updateNotificationSent',
      desc: '',
      args: [],
    );
  }

  /// `Error sending update notification. Please try again.`
  String get errorSendingUpdateNotification {
    return Intl.message(
      'Error sending update notification. Please try again.',
      name: 'errorSendingUpdateNotification',
      desc: '',
      args: [],
    );
  }

  /// `Notification scheduled for 1 minute from now`
  String get notificationScheduled {
    return Intl.message(
      'Notification scheduled for 1 minute from now',
      name: 'notificationScheduled',
      desc: '',
      args: [],
    );
  }

  /// `Error scheduling notification. Please try again.`
  String get errorSchedulingNotification {
    return Intl.message(
      'Error scheduling notification. Please try again.',
      name: 'errorSchedulingNotification',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete notification`
  String get failedToDeleteNotification {
    return Intl.message(
      'Failed to delete notification',
      name: 'failedToDeleteNotification',
      desc: '',
      args: [],
    );
  }

  /// `Notification deleted`
  String get notificationDeleted {
    return Intl.message(
      'Notification deleted',
      name: 'notificationDeleted',
      desc: '',
      args: [],
    );
  }

  /// `No date`
  String get noDate {
    return Intl.message(
      'No date',
      name: 'noDate',
      desc: '',
      args: [],
    );
  }

  /// `No title`
  String get noTitle {
    return Intl.message(
      'No title',
      name: 'noTitle',
      desc: '',
      args: [],
    );
  }

  /// `No body`
  String get noBody {
    return Intl.message(
      'No body',
      name: 'noBody',
      desc: '',
      args: [],
    );
  }

  /// `No notifications`
  String get noNotifications {
    return Intl.message(
      'No notifications',
      name: 'noNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Notification History`
  String get notificationHistoryPage {
    return Intl.message(
      'Notification History',
      name: 'notificationHistoryPage',
      desc: '',
      args: [],
    );
  }

  /// `Sent: {format}`
  String sent(Object format) {
    return Intl.message(
      'Sent: $format',
      name: 'sent',
      desc: '',
      args: [format],
    );
  }

  /// `Scheduled for: {format}`
  String scheduledFor(Object format) {
    return Intl.message(
      'Scheduled for: $format',
      name: 'scheduledFor',
      desc: '',
      args: [format],
    );
  }

  /// `Error: {string}`
  String error(Object string) {
    return Intl.message(
      'Error: $string',
      name: 'error',
      desc: '',
      args: [string],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
