abstract class LocalNotificationsRepository {
  Future<void> initialize();
  Future<void> show(
    String title,
    String body, {
    String? payload,
  });

  Stream<int> get onChatNotification;
}
