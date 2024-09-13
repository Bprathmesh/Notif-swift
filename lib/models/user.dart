import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final bool receivePromotions;
  final bool receiveUpdates;
  final bool receiveNotifications;
  final String fcmToken;
  final List<String> interests;
  final DateTime lastLogin;
  final DateTime createdAt;
  final String preferredLanguage; // New field

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.receivePromotions,
    required this.receiveUpdates,
    required this.receiveNotifications,
    required this.fcmToken,
    required this.interests,
    required this.lastLogin,
    required this.createdAt,
    required this.preferredLanguage, // New field
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      receivePromotions: map['receivePromotions'] as bool? ?? false,
      receiveUpdates: map['receiveUpdates'] as bool? ?? false,
      receiveNotifications: map['receiveNotifications'] as bool? ?? false,
      fcmToken: map['fcmToken'] as String? ?? '',
      interests: List<String>.from(map['interests'] ?? []),
      lastLogin: (map['lastLogin'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      preferredLanguage: map['preferredLanguage'] as String? ?? 'en', // New field
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'receivePromotions': receivePromotions,
      'receiveUpdates': receiveUpdates,
      'receiveNotifications': receiveNotifications,
      'fcmToken': fcmToken,
      'interests': interests,
      'lastLogin': Timestamp.fromDate(lastLogin),
      'createdAt': Timestamp.fromDate(createdAt),
      'preferredLanguage': preferredLanguage, // New field
    };
  }

  User copyWith({
    String? name,
    bool? receivePromotions,
    bool? receiveUpdates,
    bool? receiveNotifications,
    String? fcmToken,
    List<String>? interests,
    DateTime? lastLogin,
    String? preferredLanguage, // New field
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email,
      receivePromotions: receivePromotions ?? this.receivePromotions,
      receiveUpdates: receiveUpdates ?? this.receiveUpdates,
      receiveNotifications: receiveNotifications ?? this.receiveNotifications,
      fcmToken: fcmToken ?? this.fcmToken,
      interests: interests ?? this.interests,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage, // New field
    );
  }
}