import express, { Router } from 'express';
import FirebaseAdmin from '../../../data/providers/remote/firebase-admin';
import PushNotificationsRepositoryImpl from '../../../data/repositories-impl/push-notifications-repository-impl';

import PromosController from '../../controllers/v1/promos-controller';

export default (): Router => {
  const router = express.Router();
  const controller = new PromosController();
  router.post('/send-promo', controller.sendPromo);
  return router;
};
