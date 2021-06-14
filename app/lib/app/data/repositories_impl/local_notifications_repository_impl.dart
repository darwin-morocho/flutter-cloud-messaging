import 'package:fcm/app/domain/repositories/local_notifications_repository.dart';
import 'package:fcm/app/helpers/platform.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsRepositoryImpl implements LocalNotificationsRepository {
  final FlutterLocalNotificationsPlugin _plugin;

  LocalNotificationsRepositoryImpl(this._plugin);

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
  }
}
