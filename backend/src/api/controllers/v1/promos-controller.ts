import { Request, Response } from 'express';
import faker from 'faker';
import PushNotificationsRepository from '../../../domain/repositories/push-notifications-repository';

export default class PromosController {
  constructor(
    readonly pushNotificationsRepository: PushNotificationsRepository
  ) {}

  sendPromo = (req: Request, res: Response) => {
    const { title, body, imageUrl } = req.body as SendPromoBody;
    this.pushNotificationsRepository.sendNotificationToTopic({
      topic: 'promos',
      title,
      body,
      imageUrl,
      data: {
        type: 'PROMO',
        content: JSON.stringify({
          productId: faker.datatype.number(200),
          productName: faker.lorem.sentence(),
        }),
      },
    });
    res.send('OK');
  };
}

interface SendPromoBody {
  title: string;
  body: string;
  imageUrl?: string;
}
