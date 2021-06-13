import AppNotification from '../../data/db/models/app-notification';
import DeviceToken from '../../data/db/models/device-token';

export interface PushNotificationTopicData {
  topic: string;
  title: string;
  body: string;
  imageUrl?: string;
  data?: {
    [key: string]: string;
  };
}

export default interface PushNotificationsRepository {
  sendNotificationToTopic(data: PushNotificationTopicData): void;
  sendNotificationToUser(notification: AppNotification): AppNotification;
  saveDeviceToken(deviceToken: DeviceToken): number;
  updateDeviceToken(id: number, value: string): void;
  deleteDeviceToken(id: number): void;
  getNotifications(userEmail: string): AppNotification[];
  markAsViewed(id: number): void;
}
