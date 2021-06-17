import 'package:dio/dio.dart';
import 'package:fcm/app/data/providers/local/authentication_client.dart';
import 'package:fcm/app/data/providers/remote/authentication_api.dart';
import 'package:fcm/app/data/providers/remote/notifications_api.dart';
import 'package:fcm/app/data/repositories_impl/authentication_repository_impl.dart';
import 'package:fcm/app/data/repositories_impl/local_notifications_repository_impl.dart';
import 'package:fcm/app/data/repositories_impl/push_notifications_repository_impl.dart';
import 'package:fcm/app/domain/repositories/authentication_repository.dart';
import 'package:fcm/app/domain/repositories/local_notifications_repository.dart';
import 'package:fcm/app/domain/repositories/push_notifications_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> injectDependencies() async {
  final preferences = await SharedPreferences.getInstance();
  final authenticationClient = AuthenticationClient(FlutterSecureStorage());
  final dio = Dio(
    BaseOptions(baseUrl: 'http://192.168.1.104:8000'),
  );
  GetIt.I.registerLazySingleton<AuthentiactionRepository>(
    () => AuthenticationRepositoryImpl(
      authenticationClient,
      AuthenticationAPI(dio, authenticationClient),
    ),
  );

  GetIt.I.registerLazySingleton<LocalNotificationsRepository>(
    () => LocalNotificationsRepositoryImpl(FlutterLocalNotificationsPlugin()),
  );

  GetIt.I.registerLazySingleton<PushNotificationsRepository>(
    () => PushNotificationsRepositoryImpl(
      FirebaseMessaging.instance,
      NotificationsAPI(dio, authenticationClient),
      authenticationClient,
      preferences,
    ),
  );
}
