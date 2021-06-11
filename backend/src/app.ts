import express, { Application } from 'express';
import { json } from 'body-parser';
import apiV1 from './api/routes/v1';
import injectDependencies from './dependency-injection';

export default class App {
  private app: Application = express();

  async initialize(): Promise<void> {
    this.app.use(json());
    injectDependencies();
    apiV1(this.app);
    const PORT = process.env.PORT ?? 8000;
    this.app.listen(PORT, () => {
      console.log(`running on ${PORT}`);
    });
  }
}
