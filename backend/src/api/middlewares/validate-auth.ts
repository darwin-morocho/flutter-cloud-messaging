import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

export interface Session {
  email: string;
  deviceTokenId?: number;
}

declare global {
  namespace Express {
    export interface Request {
      session: Session;
    }
  }
}

export const authValidate = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const token = req.headers.token as string | undefined;
    if (!token) {
      throw new Error('missing header token');
    }
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    req.session = payload as Session;
    next();
  } catch (e) {
    res.status(401).send('access denied ');
  }
};
