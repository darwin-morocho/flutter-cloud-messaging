class _Get {
  private data: Map<String, any> = new Map();

  put<T>(key: string, dependency: T): void {
    this.data.set(key, dependency);
  }

  find<T>(key: string): T {
    if (!this.data.has(key)) {
      throw new Error(`dependency ${key}  not found`);
    }
    return this.data.get(key);
  }
}

const Get = new _Get();
export default Get;
