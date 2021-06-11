import express, { Router } from 'express';
import AuthenticationController from '../../controllers/v1/authentication-controller';

export default (): Router => {
  const router = express.Router();
  const controller = new AuthenticationController();
  router.post('/login', controller.login);
  router.post('/log-out', controller.logOut);
  return router;
};
