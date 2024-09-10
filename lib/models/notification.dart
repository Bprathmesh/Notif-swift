class Notification {
  final String title;
  final String body;

  Notification({
    required this.title,
    required this.body,
  });

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
    };
  }
}
