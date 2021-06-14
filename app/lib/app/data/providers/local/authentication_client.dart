import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationClient {
  final FlutterSecureStorage _storage;

  AuthenticationClient(this._storage);

  Future<String?> get accessToken {
    return _storage.read(key: 'token');
  }

  Future<void> saveToken(String token) {
    return _storage.write(key: 'token', value: token);
  }

  Future<void> delete() {
    return _storage.delete(key: 'token');
  }
}
