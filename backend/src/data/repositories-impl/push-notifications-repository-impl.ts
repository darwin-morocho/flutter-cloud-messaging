import PushNotificationsRepository, {
  PushNotificationTopicData,
} from '../../domain/repositories/push-notifications-repository';
import AppNotification from '../db/models/app-notification';
import DeviceToken from '../db/models/device-token';
import AppNotificationsProvider from '../providers/local/app-notifications-provider';
import DeviceTokensProvider from '../providers/local/device-tokens-provider';
import FirebaseAdmin from '../providers/remote/firebase-admin';

export default class PushNotificationsRepositoryImpl
  implements PushNotificationsRepository
{
  constructor(
    readonly firebaseAdmin: FirebaseAdmin,
    readonly deviceTokensProvider: DeviceTokensProvider,
    readonly appNotificationsProvider: AppNotificationsProvider
  ) {}

  updateDeviceToken(id: number, value: string): void {
    this.deviceTokensProvider.update(id, value);
  }

  getNotifications(userEmail: string): AppNotification[] {
    return this.appNotificationsProvider.getNotifications(userEmail);
  }

  markAsViewed(id: number): void {
    this.appNotificationsProvider.markAsViewed(id);
  }

  deleteDeviceToken(id: number): void {
    this.deviceTokensProvider.deleteById(id);
  }

  sendNotificationToUser(notification: AppNotification): AppNotification {
    const savedNotification =
      this.appNotificationsProvider.create(notification);
    const tokens = this.deviceTokensProvider.getTokens(notification.userEmail);
    if (tokens.length > 0) {
      const unreadCount = this.appNotificationsProvider.unreadCount(
        savedNotification.userEmail
      );
      this.firebaseAdmin
        .sendPushNotificationsWithTokens(tokens, savedNotification, unreadCount)
        .then((invalidTokens) => {
          // console.log('invalidTokens', invalidTokens);
          for (const token of invalidTokens) {
            this.deviceTokensProvider.deleteByValue(token);
          }
        });
    }
    return savedNotification;
  }

  saveDeviceToken(deviceToken: DeviceToken): number {
    return this.deviceTokensProvider.create(deviceToken).id!;
  }

  sendNotificationToTopic(data: PushNotificationTopicData): void {
    this.firebaseAdmin.sendPushNotificationToTopic(data);
  }
}
