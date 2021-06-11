import 'package:fcm/app/data/repositories_impl/push_notifications_repository_impl.dart';
import 'package:fcm/app/domain/repositories/push_notifications_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';

void injectDependencies() {
  GetIt.I.registerLazySingleton<PushNotificationsRepository>(
    () => PushNotificationsRepositoryImpl(FirebaseMessaging.instance),
  );
}
