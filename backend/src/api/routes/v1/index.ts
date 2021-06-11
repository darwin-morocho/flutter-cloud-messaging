import { Application } from 'express';
import promosRouter from './promos-router';
import authenticationRouter from './authentication-router';
import chatRouter from './chat-router';
import notificationsRouter from './notifications-router';

export default (app: Application) => {
  app.get('/', (req, res) => res.send('HELLO'));
  app.use('/api/v1/promos', promosRouter());
  app.use('/api/v1/auth', authenticationRouter());
  app.use('/api/v1/chat', chatRouter());
  app.use('/api/v1/notifications', notificationsRouter());
};
