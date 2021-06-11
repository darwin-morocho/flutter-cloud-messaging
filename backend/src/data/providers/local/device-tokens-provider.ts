import DeviceToken from '../../db/models/device-token';

export default class DeviceTokensProvider {
  constructor(readonly deviceTokens: DeviceToken[]) {}

  create(deviceToken: DeviceToken): DeviceToken {
    const tmp = { ...deviceToken, id: this.deviceTokens.length + 1 };
    this.deviceTokens.push(tmp);
    return tmp;
  }

  getTokens(userEmail: string): string[] {
    const list = this.deviceTokens.filter((e) => (e.userEmail = userEmail));
    return list.map((e) => e.value);
  }

  deleteById(id: number): void {
    // console.log('deleteById before ', this.deviceTokens.length);
    const index = this.deviceTokens.findIndex((e) => e.id === id);
    if (index !== -1) {
      this.deviceTokens.splice(index, 1);
    }
    // console.log('deleteById after ', this.deviceTokens.length);
  }

  deleteByValue(value: string): void {
    // console.log('deleteByValue before ', this.deviceTokens.length);
    const index = this.deviceTokens.findIndex((e) => e.value === value);
    if (index !== -1) {
      this.deviceTokens.splice(index, 1);
    }
    // console.log('deleteByValue after ', this.deviceTokens.length);
  }
}
