import { Application } from 'express';
import promosRouter from './promos-router';

export default (app: Application) => {
  app.get('/', (req, res) => res.send('HELLO'));
  app.use('/api/v1/promos', promosRouter());
};
