class User {
  final String id;
  final bool receivePromotions;
  final String fcmToken;
  final DateTime createdAt;

  User({
    required this.id,
    required this.receivePromotions,
    required this.fcmToken,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String? ?? '',
      receivePromotions: map['receivePromotions'] as bool? ?? false,
      fcmToken: map['fcmToken'] as String? ?? '',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'receivePromotions': receivePromotions,
      'fcmToken': fcmToken,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}