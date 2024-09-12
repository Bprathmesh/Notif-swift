# Push Notification App

This Flutter application demonstrates the implementation of push notifications with personalized content based on user preferences, utilizing Firebase Cloud Messaging (FCM) and local notifications with timezone handling.

## Setup Instructions

1. Clone the repository.
2. Install Flutter and Dart.
3. Run `flutter pub get` to install dependencies.
4. Set up a Firebase project, enable Firebase Cloud Messaging (FCM), and add the necessary `google-services.json` and `GoogleService-Info.plist` files for Android and iOS, respectively.
5. Open the iOS project in Xcode (`ios/Runner.xcworkspace`) and configure capabilities for Push Notifications and Background Modes.
6. Ensure you have set up the necessary entitlements for `aps-environment` for push notifications in iOS:
   - In Xcode, go to the **Signing & Capabilities** tab.
   - Add **Push Notifications** and enable **Background Modes** with **Remote notifications**.
7. Run the app using `flutter run`.

## Features
------------

* User registration and sign-in via Firebase Authentication
* User preference selection (e.g., opting in for notifications like promotions and updates)
* Scheduled and real-time push notifications using Firebase Cloud Messaging (FCM) and local notifications
* Personalized notifications based on user preferences
* Notification history view with the ability to delete notifications
* Real-time updates using Firebase Firestore streams

## Key Components

- **Firebase Authentication**: Used for user registration and sign-in.
- **Cloud Firestore**: Stores user preferences and notification history.
- **Firebase Cloud Messaging (FCM)**: Used for sending and receiving push notifications.
- **Flutter Local Notifications**: Handles scheduled and local notifications with timezone awareness.
- **TimeZone Setup**: The app dynamically configures the device's local timezone using `flutter_native_timezone` and `timezone`.

## Architecture and Design Choices

- **Authentication**: Firebase Authentication is used for user registration and sign-in.
- **Database**: Cloud Firestore stores user preferences and notification history.
- **Push Notifications**: Firebase Cloud Messaging (FCM) is used for push notifications, and local notifications are managed with Flutter Local Notifications.
- **State Management**: StatefulWidget and setState for simple state management.
- **Routing**: Flutter's named routes are used for navigation between screens.


## Features

- User registration and sign-in via Firebase Authentication.
- User preference selection (e.g., opting in for notifications like promotions and updates).
- Scheduled and real-time push notifications using Firebase Cloud Messaging (FCM) and local notifications.
- Personalized notifications based on user preferences.
- Notification history view with the ability to delete notifications.
- Real-time updates using Firebase Firestore streams.


## Code Overview

- `NotificationService`: Handles the scheduling and management of notifications, including local timezone configuration and error handling.
- Firebase Messaging and Firestore integration for fetching user data and ensuring notifications are sent according to preferences.
- `scheduleNotification`: A method that schedules notifications and ensures they respect the user's local timezone and preferences.


# Setup and Configuration
---------------------------

1. Ensure you have Firebase and FCM configured for your project.
2. Follow the setup instructions to configure iOS entitlements and capabilities in Xcode.
3. Test on both Android and iOS for full functionality, especially notifications.


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


