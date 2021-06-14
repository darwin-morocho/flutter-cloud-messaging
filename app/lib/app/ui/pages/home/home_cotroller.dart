import 'package:fcm/app/domain/models/app_notificatiin.dart';
import 'package:fcm/app/domain/repositories/authentication_repository.dart';
import 'package:fcm/app/domain/repositories/push_notifications_repository.dart';
import 'package:get_it/get_it.dart';

class HomeController {
  final _pushNotificationsRepository = GetIt.I.get<PushNotificationsRepository>();
  Stream<AppNotification> get onPromos => _pushNotificationsRepository.onNotification.where(
        (e) => e.type == AppNotificationTypes.PROMO,
      );

  Future<bool> logOut() {
    return GetIt.I.get<AuthentiactionRepository>().logOut();
  }
}
