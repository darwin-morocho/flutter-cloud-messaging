export default interface AppNotification {
  id?: number;
  title: string;
  body: string;
  type: string;
  content: string | object;
  createdAt: Date;
  viewed: boolean;
  userEmail: string;
}
