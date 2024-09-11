# Push Notification App

This Flutter application demonstrates the implementation of push notifications with personalized content based on user preferences.

## Setup Instructions

1. Clone the repository
2. Install Flutter and Dart
3. Run `flutter pub get` to install dependencies
4. Set up a Firebase project and add the necessary configuration files
5. Run the app using `flutter run`

## Architecture and Design Choices

- **Authentication**: Firebase Authentication is used for user registration and sign-in.
- **Database**: Cloud Firestore is used to store user preferences and notification history.
- **Push Notifications**: Firebase Cloud Messaging (FCM) is used for sending and receiving push notifications.
- **State Management**: The app uses StatefulWidget and setState for simple state management.
- **Routing**: Flutter's named routes are used for navigation between screens.

## Features

- User registration and sign-in
- User preference selection (receive promotions, updates)
- Personalized push notifications based on user preferences
- Notification history view with delete functionality
- Real-time updates using Firebase streams

## Future Improvements

- Implement more advanced state management solutions (e.g., Provider, Riverpod)
- Add unit and widget tests for improved reliability
- Implement localization for multi-language support
- Add support for rich notifications (images, actions)
