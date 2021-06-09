import dotEnv from 'dotenv';
import App from './app';
dotEnv.config();
const app = new App();
app.initialize();
