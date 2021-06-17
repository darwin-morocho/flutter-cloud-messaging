import 'dart:async';
import 'dart:convert';

import 'package:fcm/app/domain/models/app_notificatiin.dart';
import 'package:fcm/app/domain/repositories/local_notifications_repository.dart';
import 'package:fcm/app/helpers/platform.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsRepositoryImpl implements LocalNotificationsRepository {
  final FlutterLocalNotificationsPlugin _plugin;

  LocalNotificationsRepositoryImpl(this._plugin);
  int _id = 0;

  StreamController<int>? _chatController;

  @override
  Stream<int> get onChatNotification {
    _chatController ??= StreamController.broadcast();
    return _chatController!.stream;
  }

  @override
  Future<void> initialize() async {
    if (isAndroid) {
      final androidNotificationChannel = AndroidNotificationChannel(
        'push_notifications',
        'Push Notifications',
        'Remote notifications',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('notification'),
      );

      final impl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      impl?.createNotificationChannel(androidNotificationChannel);
    }

    final androidSettings = AndroidInitializationSettings('custom_icon');
    final iosSettings = IOSInitializationSettings();

    final settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          final json = jsonDecode(payload);
          final type = json['type'];
          if (type != null && type == AppNotificationTypes.CHAT) {
            if (_chatController != null && _chatController!.hasListener) {
              _chatController!.sink.add(json['content']['chatId']);
            }
          }
        }
      },
    );
  }

  @override
  Future<void> show(String title, String body, {String? payload}) {
    _id++;

    final android = AndroidNotificationDetails(
      'local_notifications',
      'Local notifications',
      'chat, messages, promos,etc.',
      priority: Priority.high,
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    final iOS = IOSNotificationDetails(
      presentAlert: true,
      presentSound: true,
      sound: 'notification.mp3',
    );
    final details = NotificationDetails(
      android: android,
      iOS: iOS,
    );
    return _plugin.show(
      _id,
      title,
      body,
      details,
      payload: payload,
    );
  }
}
