import 'package:fcm/app/domain/models/app_notificatiin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class PushNotificationsRepository {
  Future<AppNotification?> get initialNotification;
  Future<bool> requestPermission();
  Future<void> subscribeToTopic(String topic);
  Stream<AppNotification> get onNotification;
}
