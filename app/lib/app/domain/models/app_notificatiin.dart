class AppNotification {
  final String title, body, type;
  final dynamic content;

  AppNotification({
    required this.title,
    required this.body,
    required this.type,
    required this.content,
  });
}

class AppNotificationTypes {
  static const PROMO = "PROMO";
  static const CHAT = "CHAT";
}
