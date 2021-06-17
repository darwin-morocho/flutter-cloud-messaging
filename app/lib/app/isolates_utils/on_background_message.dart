import 'package:fcm/app/helpers/platform.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  if (isIOS) {
    final preferences = await SharedPreferences.getInstance();
    final unreadCount = message.data['unreadCount'];
    if (unreadCount != null) {
      await preferences.setInt('unreadCount', int.parse(unreadCount));
    }
  }
}
