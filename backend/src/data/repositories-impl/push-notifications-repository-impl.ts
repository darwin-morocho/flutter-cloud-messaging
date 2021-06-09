import PushNotificationsRepository, {
  PushNotificationTopicData,
} from '../../domain/repositories/push-notifications-repository';
import FirebaseAdmin from '../remote/firebase-admin';

export default class PushNotificationsRepositoryImpl
  implements PushNotificationsRepository
{
  constructor(readonly firebaseAdmin: FirebaseAdmin) {}

  sendNotificationToTopic(data: PushNotificationTopicData): void {
    this.firebaseAdmin.sendPushNotificationToTopic(data);
  }

  sendNotificationToUser(userId: string): void {}
}
