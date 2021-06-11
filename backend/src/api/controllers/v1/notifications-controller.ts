import { Request, Response } from 'express';
import { Dependencies } from '../../../dependency-injection';
import PushNotificationsRepository from '../../../domain/repositories/push-notifications-repository';
import Get from '../../../helpers/get';

export default class NotificationsController {
  private pushNotificationsRepository = Get.find<PushNotificationsRepository>(
    Dependencies.pushNotifications
  );

  getNotifications = (req: Request, res: Response) => {
    const notifications = this.pushNotificationsRepository.getNotifications(
      req.session.email
    );
    res.send(notifications);
  };

  markAsViewed = (req: Request, res: Response) => {
    try {
      const { notificationId }: { notificationId: number } = req.body;
      if (notificationId === undefined) {
        throw { code: 400, message: 'invalid body' };
      }

      this.pushNotificationsRepository.markAsViewed(notificationId);
      res.send('ok');
    } catch (e: any) {
      res.status(e.code ?? 500).send(e.message);
    }
  };
}
