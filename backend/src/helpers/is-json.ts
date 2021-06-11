const isJSon = (value: any): string | null => {
  try {
    return JSON.stringify(value);
  } catch (_) {
    return null;
  }
};

export default isJSon;
