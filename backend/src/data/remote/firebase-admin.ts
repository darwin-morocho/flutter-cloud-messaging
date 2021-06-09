import { credential, app, initializeApp, messaging } from 'firebase-admin';
import { PushNotificationTopicData } from '../../domain/repositories/push-notifications-repository';

const googleServiceJson = require('../../../firebase-admin.json');

export default class FirebaseAdmin {
  private app: app.App;

  constructor() {
    const _credential = credential.cert(googleServiceJson);
    this.app = initializeApp({ credential: _credential });
  }

  sendPushNotificationToTopic(input: PushNotificationTopicData) {
    const notification: {
      title: string;
      body: string;
      imageUrl?: string;
    } = {
      title: input.title,
      body: input.body,
    };

    if (input.imageUrl) {
      notification.imageUrl = input.imageUrl;
    }

    this.app.messaging().send({
      topic: input.topic,
      notification,
      data: input.data,
    });
  }
}
