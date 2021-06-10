"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const firebase_admin_1 = require("firebase-admin");
const googleServiceJson = require('../../../firebase-admin.json');
class FirebaseAdmin {
    constructor() {
        const _credential = firebase_admin_1.credential.cert(googleServiceJson);
        this.app = firebase_admin_1.initializeApp({ credential: _credential });
    }
    sendPushNotificationToTopic(input) {
        const notification = {
            title: input.title,
            body: input.body,
        };
        if (input.imageUrl) {
            notification.imageUrl = input.imageUrl;
        }
        this.app.messaging().send({
            topic: input.topic,
            notification,
            data: input.data,
        });
    }
}
exports.default = FirebaseAdmin;
