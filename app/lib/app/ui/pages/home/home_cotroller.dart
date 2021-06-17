import 'package:fcm/app/domain/models/app_notificatiin.dart';
import 'package:fcm/app/domain/repositories/authentication_repository.dart';
import 'package:fcm/app/domain/repositories/push_notifications_repository.dart';
import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:get_it/get_it.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class HomeController extends ChangeNotifier {
  HomeController() {
    init();
  }

  final _pushNotificationsRepository = GetIt.I.get<PushNotificationsRepository>();
  Stream<AppNotification> get onPromos => _pushNotificationsRepository.onNotification.where(
        (e) => e.type == AppNotificationTypes.PROMO,
      );

  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;

  Future<void> init() async {
    _notifications = await _pushNotificationsRepository.getNotifications();
    notifyListeners();
  }

  Future<void> markAsViewed(int id) async {
    final index = _notifications.indexWhere((e) => e.id == id);
    if (index != -1) {
      final isOk = await _pushNotificationsRepository.markAsViewed(id);
      if (isOk) {
        await _pushNotificationsRepository.updateBadgeCount();
        _notifications[index] = _notifications[index].copyWith(true);
        notifyListeners();
      }
    }
  }

  Future<bool> logOut() {
    return GetIt.I.get<AuthentiactionRepository>().logOut();
  }
}
