import 'package:fcm/app/data/providers/local/authentication_client.dart';
import 'package:fcm/app/data/providers/remote/authentication_api.dart';
import 'package:fcm/app/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthentiactionRepository {
  final AuthenticationClient _client;
  final AuthenticationAPI _authenticationAPI;
  AuthenticationRepositoryImpl(this._client, this._authenticationAPI);

  @override
  Future<String?> get accessToken => _client.accessToken;

  @override
  Future<bool> logOut() async {
    final isOk = await _authenticationAPI.logOut();
    if (isOk) {
      await _client.delete();
      return true;
    }
    return false;
  }

  @override
  Future<bool> login(String email, String? deviceToken) async {
    final accessToken = await _authenticationAPI.login(email, deviceToken);
    if (accessToken != null) {
      _client.saveToken(accessToken);
      return true;
    }
    return false;
  }
}
