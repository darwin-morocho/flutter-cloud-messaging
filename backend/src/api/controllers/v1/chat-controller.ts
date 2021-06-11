import { Request, Response } from 'express';
import faker from 'faker';
import AppNotification from '../../../data/db/models/app-notification';
import { Dependencies } from '../../../dependency-injection';
import PushNotificationsRepository from '../../../domain/repositories/push-notifications-repository';
import Get from '../../../helpers/get';

export default class ChatController {
  private pushNotificationsRepository = Get.find<PushNotificationsRepository>(
    Dependencies.pushNotifications
  );

  sendMessage = (req: Request, res: Response) => {
    try {
      const { chatId, value, type, email } = req.body as MessageBody;
      if (!chatId || !value || !type || !email) {
        throw { code: 400, message: 'invalid body' };
      }
      const notification: AppNotification = {
        userEmail: email,
        title: `nuevo mensaje en el chat  ${chatId}`,
        body: faker.lorem.sentence(),
        type: 'CHAT',
        content: {
          chatId,
          value,
          type,
          createdAt: new Date(),
        },
        createdAt: new Date(),
        viewed: false,
      };

      this.pushNotificationsRepository.sendNotificationToUser(notification);
      res.send('ok');
    } catch (e: any) {
      res.status(e.code ?? 500).send(e.message);
    }
  };
}

interface MessageBody {
  chatId: number;
  value: string;
  email: string;
  type: 'text' | 'image' | 'audio';
}
