import express, { Router } from 'express';
import ChatController from '../../controllers/v1/chat-controller';

export default (): Router => {
  const router = express.Router();
  const controller = new ChatController();
  router.post('/send-message', controller.sendMessage);
  return router;
};
