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
  sendNotificationToUser(userId: string): void;
}
