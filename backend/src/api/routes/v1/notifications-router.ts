import express, { Router } from 'express';
import NotificationsController from '../../controllers/v1/notifications-controller';
import { authValidate } from '../../middlewares/validate-auth';

export default (): Router => {
  const router = express.Router();
  const controller = new NotificationsController();
  router.get('/get', authValidate, controller.getNotifications);
  router.post('/mark-as-viewed', authValidate, controller.markAsViewed);
  return router;
};
