# Push Notification App

## Overview

This Flutter application demonstrates the implementation of push notifications with personalized content based on user preferences, utilizing Firebase Cloud Messaging (FCM) and local notifications with timezone handling.

## Features
------------

* User registration and sign-in via Firebase Authentication
* User preference selection (e.g., opting in for notifications like promotions and updates)
* Scheduled and real-time push notifications using Firebase Cloud Messaging (FCM) and local notifications
* Personalized notifications based on user preferences
* Notification history view with the ability to delete notifications
* Real-time updates using Firebase Firestore streams

## Key Components

- **Authentication**: Firebase Authentication is used for user registration and sign-in.
- **Database**: Cloud Firestore stores user preferences and notification history.
- **Push Notifications**: Firebase Cloud Messaging (FCM) is used for sending and receiving push notifications, and local notifications are managed with Flutter Local Notifications.
- **Firebase Authentication**: Used for user registration and sign-in.
- **Cloud Firestore**: Stores user preferences and notification history.
- **Firebase Cloud Messaging (FCM)**: Used for sending and receiving push notifications.
- **Flutter Local Notifications**: Handles scheduled and local notifications with timezone awareness.
- **TimeZone Setup**: The app dynamically configures the device's local timezone using `flutter_native_timezone` and `timezone`.

## Architecture and Design Choices

- **Authentication**: Firebase Authentication for user registration and sign-in
- **Database**: Cloud Firestore for storing user preferences and notification history
- **Push Notifications**: Firebase Cloud Messaging (FCM) for push notifications, Flutter Local Notifications for local notifications
- **State Management**: StatefulWidget and setState for simple state management
- **Routing**: Flutter's named routes for navigation between screens
- **Timezone Handling**: Dynamic configuration of device's local timezone using `flutter_native_timezone` and `timezone`

## Key Components

- **NotificationService**: Handles scheduling and management of notifications, including local timezone configuration and error handling
- **Firebase Integration**: Messaging and Firestore integration for fetching user data and ensuring notifications are sent according to preferences
- **Scheduled Notifications**: Implemented with respect to user's local timezone and preferences

## Setup Instructions

1. Clone the repository
2. Install Flutter and Dart
3. Run `flutter pub get` to install dependencies
4. Set up a Firebase project:
   - Enable Firebase Cloud Messaging (FCM)
   - Add the necessary `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files
5. iOS-specific setup:
   - Open the iOS project in Xcode (`ios/Runner.xcworkspace`)
   - Configure capabilities for Push Notifications and Background Modes
   - Set up the necessary entitlements for `aps-environment`:
     - In Xcode, go to the **Signing & Capabilities** tab
     - Add **Push Notifications**
     - Enable **Background Modes** with **Remote notifications**
6. Run the app using `flutter run`

## Running the Project

1. Ensure Firebase and FCM are properly configured for your project
2. Verify iOS entitlements and capabilities are set up in Xcode
3. Test on both Android and iOS devices for full functionality, especially notifications

## Code Overview

- `NotificationService`: Central component for notification management
- Firebase Messaging and Firestore integration for user data and preference-based notifications
- `scheduleNotification`: Method for scheduling timezone-aware notifications respecting user preferences

## Future Improvements

- Implement more advanced state management solutions (e.g., Provider, Riverpod).
- Add unit and widget tests for improved reliability.
- Implement localization for multi-language support.
- Add support for rich notifications (images, actions).
- Improve notification customization based on user segmentation.

## Running the Project

1. Ensure you have Firebase and FCM configured for your project.
2. Follow the setup instructions to configure iOS entitlements and capabilities in Xcode.
3. Test on both Android and iOS for full functionality, especially notifications.


<<<<<<<  d8d871c5-3f94-42f2-a777-b795c73fe471  >>>>>>>