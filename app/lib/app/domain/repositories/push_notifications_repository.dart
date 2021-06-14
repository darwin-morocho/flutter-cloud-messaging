import 'package:fcm/app/domain/models/app_notificatiin.dart';

abstract class PushNotificationsRepository {
  Future<String?> get deviceToken;
  Future<AppNotification?> get initialNotification;
  Future<bool> requestPermission();
  Future<void> subscribeToTopic(String topic);
  Stream<AppNotification> get onNotification;
}
