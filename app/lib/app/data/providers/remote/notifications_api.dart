import 'package:dio/dio.dart';
import 'package:fcm/app/data/providers/local/authentication_client.dart';
import 'package:fcm/app/domain/models/app_notificatiin.dart';

class NotificationsAPI {
  final Dio _httpClient;
  final AuthenticationClient _authenticationClient;
  NotificationsAPI(this._httpClient, this._authenticationClient);

  Future<List<AppNotification>> getNotifications() async {
    try {
      final accessToken = await _authenticationClient.accessToken;
      final response = await _httpClient.get(
        '/api/v1/notifications/get',
        options: Options(headers: {
          "token": accessToken,
        }),
      );
      return (response.data as List)
          .map(
            (e) => AppNotification.fromJson(e),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> markAsViewed(int id) async {
    try {
      final accessToken = await _authenticationClient.accessToken;
      await _httpClient.post(
        '/api/v1/notifications/mark-as-viewed',
        options: Options(headers: {
          "token": accessToken,
        }),
        data: {"notificationId": id},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateToken(String deviceToken, String accessToken) async {
    try {
      await _httpClient.post(
        '/api/v1/notifications/update-token',
        options: Options(headers: {
          "token": accessToken,
        }),
        data: {
          "pushNotificationToken": deviceToken,
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
