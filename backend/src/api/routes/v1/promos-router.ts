import express, { Router } from 'express';
import FirebaseAdmin from '../../../data/remote/firebase-admin';
import PushNotificationsRepositoryImpl from '../../../data/repositories-impl/push-notifications-repository-impl';

import PromosController from '../../controllers/v1/promos-controller';

export default (): Router => {
  const router = express.Router();
  const controller = new PromosController(
    new PushNotificationsRepositoryImpl(new FirebaseAdmin())
  );
  router.post('/send-promo', controller.sendPromo);
  return router;
};
