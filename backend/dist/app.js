"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const body_parser_1 = require("body-parser");
const v1_1 = __importDefault(require("./api/routes/v1"));
class App {
    constructor() {
        this.app = express_1.default();
    }
    initialize() {
        var _a;
        return __awaiter(this, void 0, void 0, function* () {
            this.app.use(body_parser_1.json());
            v1_1.default(this.app);
            const PORT = (_a = process.env.PORT) !== null && _a !== void 0 ? _a : 8000;
            this.app.listen(PORT, () => {
                console.log(`running on ${PORT}`);
            });
        });
    }
}
exports.default = App;
