import 'package:fcm/app/domain/repositories/authentication_repository.dart';
import 'package:fcm/app/domain/repositories/push_notifications_repository.dart';
import 'package:get_it/get_it.dart';

class LoginController {
  final _pushNotificationsRepository = GetIt.I.get<PushNotificationsRepository>();
  final _authentiactionRepository = GetIt.I.get<AuthentiactionRepository>();
  String _email = '';

  void onEmailChanged(String text) {
    _email = text;
  }

  Future<bool> submit() async {
    final deviceToken = await _pushNotificationsRepository.deviceToken;
    return _authentiactionRepository.login(_email, deviceToken);
  }
}
