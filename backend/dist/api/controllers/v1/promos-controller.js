"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const faker_1 = __importDefault(require("faker"));
class PromosController {
    constructor(pushNotificationsRepository) {
        this.pushNotificationsRepository = pushNotificationsRepository;
        this.sendPromo = (req, res) => {
            const { title, body, imageUrl } = req.body;
            this.pushNotificationsRepository.sendNotificationToTopic({
                topic: 'promos',
                title,
                body,
                imageUrl,
                data: {
                    type: 'PROMO',
                    content: JSON.stringify({
                        productId: faker_1.default.datatype.number(200),
                        productName: faker_1.default.lorem.sentence(),
                    }),
                },
            });
            res.send('OK');
        };
    }
}
exports.default = PromosController;
