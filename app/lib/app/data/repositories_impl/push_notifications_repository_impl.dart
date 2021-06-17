import 'dart:async';
import 'dart:convert';

import 'package:fcm/app/data/providers/local/authentication_client.dart';
import 'package:fcm/app/data/providers/remote/notifications_api.dart';
import 'package:fcm/app/domain/models/app_notificatiin.dart';
import 'package:fcm/app/domain/repositories/push_notifications_repository.dart';
import 'package:fcm/app/helpers/platform.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationsRepositoryImpl implements PushNotificationsRepository {
  final FirebaseMessaging _messaging;
  final AuthenticationClient _authenticationClient;
  final NotificationsAPI _notificationsAPI;
  final SharedPreferences _preferences;

  StreamController<AppNotification>? _streamController;

  PushNotificationsRepositoryImpl(
    this._messaging,
    this._notificationsAPI,
    this._authenticationClient,
    this._preferences,
  ) {
    _init();
  }

  @override
  Future<int> get unreadCount async {
    await this._preferences.reload();
    final count = this._preferences.getInt('unreadCount') ?? 0;
    return count;
  }

  @override
  Future<String?> get deviceToken => _messaging.getToken();

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
    _messaging.onTokenRefresh.listen((deviceToken) async {
      final accessToken = await _authenticationClient.accessToken;
      if (accessToken != null) {
        _notificationsAPI.updateToken(deviceToken, accessToken);
      }
    });
  }

  AppNotification? _appNotificationFromMessage(RemoteMessage message) {
    final notification = message.notification;
    final type = message.data['type'];
    if (notification != null && type != null) {
      dynamic content;
      if (type == AppNotificationTypes.PROMO) {
        content = jsonDecode(message.data['content']);
      } else if (type == AppNotificationTypes.CHAT) {
        content = jsonDecode(message.data['content']);
      }

      return AppNotification(
        title: notification.title ?? '',
        body: notification.body ?? '',
        type: type,
        content: content,
        viewed: true,
        createdAt: DateTime.now(),
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

  @override
  Future<List<AppNotification>> getNotifications() {
    return _notificationsAPI.getNotifications();
  }

  @override
  Future<bool> markAsViewed(int id) {
    return _notificationsAPI.markAsViewed(id);
  }

  @override
  Future<void> updateBadgeCount() async {
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      // FlutterAppBadger.removeBadge();
      final count = await this.unreadCount;
      if (count > 0) {
        FlutterAppBadger.updateBadgeCount(count - 1);
        _preferences.setInt('unreadCount', count - 1);
      }
    }
  }
}
