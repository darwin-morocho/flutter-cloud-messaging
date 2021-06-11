import AppNotification from '../../db/models/app-notification';

export default class AppNotificationsProvider {
  constructor(readonly notications: AppNotification[]) {}

  create(notification: AppNotification): AppNotification {
    const tmp = { ...notification, id: this.notications.length + 1 };
    this.notications.push(tmp);
    return tmp;
  }

  getNotifications(userEmail: string): AppNotification[] {
    return this.notications.filter((e) => e.userEmail === userEmail);
  }

  markAsViewed(id: number): void {
    const index = this.notications.findIndex((e) => e.id === id);
    if (index !== -1) {
      this.notications[index] = { ...this.notications[index], viewed: true };
    }
  }

  delete(id: number): void {
    const index = this.notications.findIndex((e) => e.id === id);
    if (index !== -1) {
      this.notications.splice(index, 1);
    }
  }
}
