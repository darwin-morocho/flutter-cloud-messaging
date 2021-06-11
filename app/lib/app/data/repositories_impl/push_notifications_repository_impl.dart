import 'dart:async';
import 'dart:convert';

import 'package:fcm/app/domain/models/app_notificatiin.dart';
import 'package:fcm/app/domain/repositories/push_notifications_repository.dart';
import 'package:fcm/app/helpers/platform.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsRepositoryImpl implements PushNotificationsRepository {
  final FirebaseMessaging _messaging;

  StreamController<AppNotification>? _streamController;

  PushNotificationsRepositoryImpl(this._messaging) {
    _init();
  }

  @override
  Stream<AppNotification> get onNotification {
    // _streamController = _streamController ?? StreamController.broadcast();
    _streamController ??= StreamController.broadcast();
    return _streamController!.stream;
  }

  @override
  Future<AppNotification?> get initialNotification async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      return _appNotificationFromMessage(message);
    }
    return null;
  }

  void _init() {
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessage);
  }

  AppNotification? _appNotificationFromMessage(RemoteMessage message) {
    final notification = message.notification;
    final type = message.data['type'];
    if (notification != null && type != null) {
      dynamic content;
      if (type == AppNotificationTypes.PROMO) {
        content = jsonDecode(message.data['content']);
      }

      return AppNotification(
        title: notification.title ?? '',
        body: notification.body ?? '',
        type: type,
        content: content,
      );
    }
    return null;
  }

  void _onMessage(RemoteMessage message) {
    final appNotification = _appNotificationFromMessage(message);
    if (appNotification != null && _streamController != null && _streamController!.hasListener) {
      _streamController!.sink.add(appNotification);
    }
  }

  @override
  Future<bool> requestPermission() async {
    if (isIOS) {
      final settings = await _messaging.requestPermission();
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    }
    return true;
  }

  @override
  Future<void> subscribeToTopic(String topic) {
    return _messaging.subscribeToTopic(topic);
  }
}
