import dataPreferences from '@ohos.data.preferences';
import hilog from '@ohos.hilog';
import { Callback } from './CallBackType';

type ValueType = number | string | boolean | Array<number> | Array<string> | Array<boolean>;

export default class PreferencesManager {
  private context: Context;
  private name: string;
  private preferencesInstance: dataPreferences.Preferences;

  constructor(context: Context, name: string) {
    this.context = context;
    this.name = name;
  }

  private createPreferences(callback: Callback<Boolean>) {
    dataPreferences.getPreferences(this.context, this.name, (err, preferences) => {
      if (err) {
        callback(false);
        return;
      }

      this.preferencesInstance = preferences as dataPreferences.Preferences;
      callback(true);
    })
  }

  getData<T extends ValueType>(key: string, defaultValue: T): Promise<T> {
    return new Promise((resolve: Function, reject: Function) => {
      this.createPreferences((isSuccess) => {
        if (this.preferencesInstance) {
          this.preferencesInstance.get(key, defaultValue).then((value: T) => {
            hilog.info(0x0000, 'zwx', '%{public}s', `读取数据: key: ${key}, value = ${value}`);
            resolve(value);
          }).catch((e) => {
            console.error(`获取 value 失败. Code: ${e.code}, message: ${e.message}`)
            reject(e);
          });
        }
      })
    });
  }

  putData<T extends ValueType>(key: string, value: T): Promise<void> {
    return new Promise((resolve: Function, reject: Function) => {
      this.createPreferences((isSuccess) => {
        if (this.preferencesInstance) {
          hilog.info(0x0000, 'zwx', '%{public}s', `保存数据: key: ${key}, value = ${value}`);
          this.preferencesInstance.put(key, value);
          this.flush()
          resolve();
        } else {
          reject(new Error("preferencesInstance 不存在"));
        }
      });
    });
  }

  private flush(): Promise<void> {
    return new Promise((resolve: Function, reject: Function) => {
      this.createPreferences((isSuccess) => {
        if (this.preferencesInstance) {
          this.preferencesInstance.flush((err) => {
            if (err) {
              reject(new Error("flush 失败"));
            } else {
              resolve();
            }
          });
        };
      });
    });
  }

  hasKey(key: string): Promise<Boolean> {
    return new Promise((resolve: Function, reject: Function) => {
      this.createPreferences((isSuccess) => {
        if (this.preferencesInstance) {
          this.preferencesInstance.has(key).then((value: Boolean) => {
            resolve(value);
          }).catch((e) => {
             reject(e);
          });
        } else {
          reject(new Error("preferencesInstance 不存在"));
        }
      });
    });
  }

  delete(key): Promise<boolean> {
    return new Promise((resolve: Function, reject: Function) => {
      this.createPreferences((isSuccess) => {
        if (this.preferencesInstance) {
          this.preferencesInstance.delete(key).then((err) => {
            let isSuccess = err == null;
            resolve(isSuccess);
            hilog.info(0x0000, 'zwx', '%{public}s', `删除数据: key: ${key}, isSucc: ${isSuccess}`);
            this.flush();
          }).catch((e) => {
            resolve(false);
          });
        } else {
          reject(new Error("preferencesInstance 不存在"));
        }
      });
    });
  }

  deletePreference(): Promise<Boolean> {
    return new Promise((resolve: Function, reject: Function) => {
      dataPreferences.deletePreferences(this.context, this.name, (err, val) => {
        if (err) {
          resolve(false);
          return;
        }

        resolve(true);
      })
    });
  }
}