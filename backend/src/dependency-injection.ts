import AppNotificationsProvider from './data/providers/local/app-notifications-provider';
import DeviceTokensProvider from './data/providers/local/device-tokens-provider';
import FirebaseAdmin from './data/providers/remote/firebase-admin';
import PushNotificationsRepositoryImpl from './data/repositories-impl/push-notifications-repository-impl';
import PushNotificationsRepository from './domain/repositories/push-notifications-repository';
import Get from './helpers/get';

export enum Dependencies {
  pushNotifications = 'pushNotifications',
  users = 'users',
}

const injectDependencies = (): void => {
  const firebaseAdmin = new FirebaseAdmin();

  const deviceTokensProvider = new DeviceTokensProvider([]);
  const appNotificationsProvider = new AppNotificationsProvider([]);

  Get.put<PushNotificationsRepository>(
    Dependencies.pushNotifications,
    new PushNotificationsRepositoryImpl(
      firebaseAdmin,
      deviceTokensProvider,
      appNotificationsProvider
    )
  );

};

export default injectDependencies;
