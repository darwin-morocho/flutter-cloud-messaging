import 'package:dio/dio.dart';
import 'package:fcm/app/data/providers/local/authentication_client.dart';

class AuthenticationAPI {
  final Dio _httpClient;
  final AuthenticationClient _authenticationClient;
  AuthenticationAPI(this._httpClient, this._authenticationClient);

  Future<String?> login(String email, String? deviceToken) async {
    try {
      final response = await _httpClient.post(
        '/api/v1/auth/login',
        data: {
          "email": email,
          "pushNotificationToken": deviceToken,
        },
      );
      return response.data['token'];
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> logOut() async {
    try {
      final accessToken = await _authenticationClient.accessToken;
      await _httpClient.post(
        '/api/v1/auth/log-out',
        options: Options(headers: {
          "token": accessToken,
        }),
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
