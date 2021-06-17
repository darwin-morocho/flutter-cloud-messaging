import 'package:fcm/app/domain/models/app_notificatiin.dart';

abstract class PushNotificationsRepository {
  Future<String?> get deviceToken;
  Future<int> get unreadCount;
  Future<AppNotification?> get initialNotification;
  Future<bool> requestPermission();
  Future<void> subscribeToTopic(String topic);
  Stream<AppNotification> get onNotification;
  Future<List<AppNotification>> getNotifications();
  Future<bool> markAsViewed(int id);
  Future<void> updateBadgeCount();
}
