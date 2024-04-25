import dataPreferences from '@ohos.data.preferences';
import { Callback } from './CallBackType';
import common from '@ohos.app.ability.common';

type ValueType = number | string | boolean | Array<number> | Array<string> | Array<boolean>;

export default class PreferencesManager {
  private context: common.Context;
  private name: string;
  private preferencesInstance: dataPreferences.Preferences;

  constructor(context: common.Context, name: string) {
    this.context = context;
    this.name = name;
  }

  private createPreferences(callback: Callback<Boolean>) {
    dataPreferences.getPreferences(this.context, this.name, (err, prefercences) => {
      if (err) {
        callback(false);
        return;
      }

      this.preferencesInstance = prefercences as dataPreferences.Preferences;
      callback(true);
    })
  }

  getData<T extends ValueType>(key: string, defaultValue: T): Promise<T> {
    return new Promise((resolve: Function, reject: Function) => {
      this.createPreferences((isSuccess) => {
        if (this.preferencesInstance) {
          this.preferencesInstance.get(key, defaultValue).then((value: T) => {
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

  delete(key): Promise<Boolean> {
    return new Promise((resolve: Function, reject: Function) => {
      this.createPreferences((isSuccess) => {
        if (this.preferencesInstance) {
          this.preferencesInstance.delete(key).then((err) => {
            resolve(err != null);
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