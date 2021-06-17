import 'package:fcm/app/domain/models/app_notificatiin.dart';
import 'package:fcm/app/domain/repositories/authentication_repository.dart';
import 'package:fcm/app/domain/repositories/push_notifications_repository.dart';
import 'package:fcm/app/ui/routes/routes.dart';
import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:get_it/get_it.dart';

class SplashController extends ChangeNotifier {
  SplashController() {}

  String? _routeName;
  String? get routeName => _routeName;

  Object? _pageArguments;
  Object? get pageArguments => _pageArguments;

  final _authentiactionRepository = GetIt.I.get<AuthentiactionRepository>();
  final _pushNotificationsRepository = GetIt.I.get<PushNotificationsRepository>();

  Future<void> init() async {
    final accessToken = await _authentiactionRepository.accessToken;
    if (accessToken != null) {}
    final initialNotification = await _pushNotificationsRepository.initialNotification;

    print("initialNotification != null ${initialNotification != null}");
    if (initialNotification != null) {
      switch (initialNotification.type) {
        case AppNotificationTypes.PROMO:
          _pageArguments = initialNotification.content['productId'];
          _routeName = Routes.PROMO;
          break;
        case AppNotificationTypes.CHAT:
          _pageArguments = initialNotification.content['chatId'];
          _routeName = Routes.CHAT;
          break;
      }
    } else {
      _routeName = accessToken != null ? Routes.HOME : Routes.LOGIN;
    }
    notifyListeners();
  }
}
