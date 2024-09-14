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

  /// `Change Theme`
  String get changeTheme {
    return Intl.message(
      'Change Theme',
      name: 'changeTheme',
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

  /// `Error fetching notifications. Please try again.`
  String get errorFetchingNotifications {
    return Intl.message(
      'Error fetching notifications. Please try again.',
      name: 'errorFetchingNotifications',
      desc: '',
      args: [],
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

  /// `This is a test scheduled notification`
  String get scheduledNotificationBody {
    return Intl.message(
      'This is a test scheduled notification',
      name: 'scheduledNotificationBody',
      desc: '',
      args: [],
    );
  }

  /// `Technology`
  String get technology {
    return Intl.message(
      'Technology',
      name: 'technology',
      desc: '',
      args: [],
    );
  }

  /// `Sports`
  String get sports {
    return Intl.message(
      'Sports',
      name: 'sports',
      desc: '',
      args: [],
    );
  }

  /// `Music`
  String get music {
    return Intl.message(
      'Music',
      name: 'music',
      desc: '',
      args: [],
    );
  }

  /// `Travel`
  String get travel {
    return Intl.message(
      'Travel',
      name: 'travel',
      desc: '',
      args: [],
    );
  }

  /// `Food`
  String get food {
    return Intl.message(
      'Food',
      name: 'food',
      desc: '',
      args: [],
    );
  }

  /// `Fashion`
  String get fashion {
    return Intl.message(
      'Fashion',
      name: 'fashion',
      desc: '',
      args: [],
    );
  }

  /// `Health`
  String get health {
    return Intl.message(
      'Health',
      name: 'health',
      desc: '',
      args: [],
    );
  }

  /// `Finance`
  String get finance {
    return Intl.message(
      'Finance',
      name: 'finance',
      desc: '',
      args: [],
    );
  }

  /// `New tech gadget launched!`
  String get technologyMessage1 {
    return Intl.message(
      'New tech gadget launched!',
      name: 'technologyMessage1',
      desc: '',
      args: [],
    );
  }

  /// `Breaking news on AI development!`
  String get technologyMessage2 {
    return Intl.message(
      'Breaking news on AI development!',
      name: 'technologyMessage2',
      desc: '',
      args: [],
    );
  }

  /// `Discover the latest in smart home technology.`
  String get technologyMessage3 {
    return Intl.message(
      'Discover the latest in smart home technology.',
      name: 'technologyMessage3',
      desc: '',
      args: [],
    );
  }

  /// `Big match alert! Don’t miss the action.`
  String get sportsMessage1 {
    return Intl.message(
      'Big match alert! Don’t miss the action.',
      name: 'sportsMessage1',
      desc: '',
      args: [],
    );
  }

  /// `Your favorite team has an upcoming match!`
  String get sportsMessage2 {
    return Intl.message(
      'Your favorite team has an upcoming match!',
      name: 'sportsMessage2',
      desc: '',
      args: [],
    );
  }

  /// `New sports gear available.`
  String get sportsMessage3 {
    return Intl.message(
      'New sports gear available.',
      name: 'sportsMessage3',
      desc: '',
      args: [],
    );
  }

  /// `Your favorite artist just released a new album!`
  String get musicMessage1 {
    return Intl.message(
      'Your favorite artist just released a new album!',
      name: 'musicMessage1',
      desc: '',
      args: [],
    );
  }

  /// `Tickets for an upcoming concert are now on sale.`
  String get musicMessage2 {
    return Intl.message(
      'Tickets for an upcoming concert are now on sale.',
      name: 'musicMessage2',
      desc: '',
      args: [],
    );
  }

  /// `Discover this week’s top hits.`
  String get musicMessage3 {
    return Intl.message(
      'Discover this week’s top hits.',
      name: 'musicMessage3',
      desc: '',
      args: [],
    );
  }

  /// `Dreaming of a getaway? Check out our latest travel deals!`
  String get travelMessage1 {
    return Intl.message(
      'Dreaming of a getaway? Check out our latest travel deals!',
      name: 'travelMessage1',
      desc: '',
      args: [],
    );
  }

  /// `Explore new destinations with our travel guide.`
  String get travelMessage2 {
    return Intl.message(
      'Explore new destinations with our travel guide.',
      name: 'travelMessage2',
      desc: '',
      args: [],
    );
  }

  /// `Last-minute vacation packages available!`
  String get travelMessage3 {
    return Intl.message(
      'Last-minute vacation packages available!',
      name: 'travelMessage3',
      desc: '',
      args: [],
    );
  }

  /// `Hungry? Discover new recipes from your favorite cuisine.`
  String get foodMessage1 {
    return Intl.message(
      'Hungry? Discover new recipes from your favorite cuisine.',
      name: 'foodMessage1',
      desc: '',
      args: [],
    );
  }

  /// `Top-rated restaurants near you with special offers!`
  String get foodMessage2 {
    return Intl.message(
      'Top-rated restaurants near you with special offers!',
      name: 'foodMessage2',
      desc: '',
      args: [],
    );
  }

  /// `New cooking tutorial: Learn to make gourmet dishes at home.`
  String get foodMessage3 {
    return Intl.message(
      'New cooking tutorial: Learn to make gourmet dishes at home.',
      name: 'foodMessage3',
      desc: '',
      args: [],
    );
  }

  /// `We have exciting news for you!`
  String get defaultMessage {
    return Intl.message(
      'We have exciting news for you!',
      name: 'defaultMessage',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Spanish`
  String get spanish {
    return Intl.message(
      'Spanish',
      name: 'spanish',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your name`
  String get pleaseEnterName {
    return Intl.message(
      'Please enter your name',
      name: 'pleaseEnterName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an email`
  String get pleaseEnterEmail {
    return Intl.message(
      'Please enter an email',
      name: 'pleaseEnterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordMustBe6Chars {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordMustBe6Chars',
      desc: '',
      args: [],
    );
  }

  /// `Receive Promotions`
  String get receivePromotions {
    return Intl.message(
      'Receive Promotions',
      name: 'receivePromotions',
      desc: '',
      args: [],
    );
  }

  /// `Receive Updates`
  String get receiveUpdates {
    return Intl.message(
      'Receive Updates',
      name: 'receiveUpdates',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed: {error}`
  String registrationFailed(Object error) {
    return Intl.message(
      'Registration failed: $error',
      name: 'registrationFailed',
      desc: '',
      args: [error],
    );
  }

  /// `Welcome Back!`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back!',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Create an account`
  String get createAccount {
    return Intl.message(
      'Create an account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Preferences`
  String get preferences {
    return Intl.message(
      'Preferences',
      name: 'preferences',
      desc: '',
      args: [],
    );
  }

  /// `Preferences saved successfully`
  String get preferencesSaved {
    return Intl.message(
      'Preferences saved successfully',
      name: 'preferencesSaved',
      desc: '',
      args: [],
    );
  }

  /// `Preferences Updated`
  String get preferencesUpdated {
    return Intl.message(
      'Preferences Updated',
      name: 'preferencesUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Your notification preferences have been updated.`
  String get notificationPreferencesUpdated {
    return Intl.message(
      'Your notification preferences have been updated.',
      name: 'notificationPreferencesUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save preferences: {error}`
  String failedToSavePreferences(Object error) {
    return Intl.message(
      'Failed to save preferences: $error',
      name: 'failedToSavePreferences',
      desc: '',
      args: [error],
    );
  }

  /// `Interests`
  String get interests {
    return Intl.message(
      'Interests',
      name: 'interests',
      desc: '',
      args: [],
    );
  }

  /// `{interest}`
  String interest(Object interest) {
    return Intl.message(
      '$interest',
      name: 'interest',
      desc: '',
      args: [interest],
    );
  }

  /// `Save Preferences`
  String get savePreferences {
    return Intl.message(
      'Save Preferences',
      name: 'savePreferences',
      desc: '',
      args: [],
    );
  }

  /// `Hello {name}`
  String hello(Object name) {
    return Intl.message(
      'Hello $name',
      name: 'hello',
      desc: '',
      args: [name],
    );
  }

  /// `Special Offer!`
  String get promotionalNotificationTitle {
    return Intl.message(
      'Special Offer!',
      name: 'promotionalNotificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `{name}, check out our latest promotion!`
  String promotionalNotificationBody(Object name) {
    return Intl.message(
      '$name, check out our latest promotion!',
      name: 'promotionalNotificationBody',
      desc: '',
      args: [name],
    );
  }

  /// `User`
  String get user {
    return Intl.message(
      'User',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `App Update`
  String get updateNotificationTitle {
    return Intl.message(
      'App Update',
      name: 'updateNotificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `We have some exciting new features for you. Update now to explore!`
  String get updateNotificationBody {
    return Intl.message(
      'We have some exciting new features for you. Update now to explore!',
      name: 'updateNotificationBody',
      desc: '',
      args: [],
    );
  }

  /// `Scheduled Notification`
  String get scheduledNotificationTitle {
    return Intl.message(
      'Scheduled Notification',
      name: 'scheduledNotificationTitle',
      desc: '',
      args: [],
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
