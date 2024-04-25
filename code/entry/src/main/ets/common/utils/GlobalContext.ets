/**
 * 一个保存对象的全家单例类
 */

export class GlobalContext {
  private constructor() {
  }

  private static instance: GlobalContext;
  private objects = new Map<string, Object>();

  public static getContext(): GlobalContext {
    if (!GlobalContext.instance) {
      GlobalContext.instance = new GlobalContext();
    }
    return GlobalContext.instance;
  }

  getObject(value: string): Object | undefined {
    return this.objects.get(value);
  }

  setObject(key: string, objectClass: Object): void {
    this.objects.set(key, objectClass);
  }
}