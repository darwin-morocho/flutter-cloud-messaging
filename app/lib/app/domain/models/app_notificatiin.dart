class AppNotification {
  final String title, body, type;
  final dynamic content;
  final DateTime createdAt;
  final bool viewed;
  final int? id;

  AppNotification({
    required this.title,
    required this.body,
    required this.type,
    required this.content,
    required this.createdAt,
    required this.viewed,
    this.id,
  });

  AppNotification copyWith(bool viewed) {
    return AppNotification(
      title: this.title,
      body: this.body,
      type: this.type,
      content: this.content,
      createdAt: this.createdAt,
      viewed: viewed,
    );
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      viewed: json['viewed'],
      title: json['title'],
      body: json['body'],
      type: json['type'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class AppNotificationTypes {
  static const PROMO = "PROMO";
  static const CHAT = "CHAT";
}
