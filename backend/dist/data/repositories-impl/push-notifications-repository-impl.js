"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class PushNotificationsRepositoryImpl {
    constructor(firebaseAdmin) {
        this.firebaseAdmin = firebaseAdmin;
    }
    sendNotificationToTopic(data) {
        this.firebaseAdmin.sendPushNotificationToTopic(data);
    }
    sendNotificationToUser(userId) { }
}
exports.default = PushNotificationsRepositoryImpl;
