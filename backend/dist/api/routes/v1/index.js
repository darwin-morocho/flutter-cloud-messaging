"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const promos_router_1 = __importDefault(require("./promos-router"));
exports.default = (app) => {
    app.get('/', (req, res) => res.send('HELLO'));
    app.use('/api/v1/promos', promos_router_1.default());
};
