
import distributedKVStore from '@ohos.data.distributedKVStore'

/**
 * 分布式键值数据库 管理器
 * 使用 SingleKVStore, 数据不对设备进行区分
 * 数据库配置已固定, 后期如有需要再提供更多配置
 * 提供读写方法
 * 对 Promise的使用可能不成熟, 待进一步学习后改进
 */

export default class KeyStorageManager {
  private config: distributedKVStore.KVManagerConfig;
  // 只能包含字母数字或者下划线, 否则会报错
  private storeId: string;
  private kvManager: distributedKVStore.KVManager;
  private kvStorage: distributedKVStore.SingleKVStore;
  private options = {
    createIfMissing: true, // 当数据库文件不存在时是否创建数据库，默认创建
    encrypt: false, // 设置数据库文件是否加密，默认不加密
    backup: false, // 设置数据库文件是否备份，默认备份
    kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION, // 设置要创建的数据库类型，默认为多设备协同数据库
    securityLevel: distributedKVStore.SecurityLevel.S2 // 设置数据库安全级别
  };

  constructor(config: distributedKVStore.KVManagerConfig, storeId: string) {
    this.config = config;
    this.storeId = storeId;

    try {
       this.kvManager = distributedKVStore.createKVManager(this.config);
    } catch (e) {
      console.error(`创建 KVManager 失败. Code: ${e.code}, message: ${e.message}`)
    }
  }

  private createKVStore(callback: {(Boolean): void}) {
      if (this.kvStorage) {
        callback(true);
      } else {
        this.kvManager.getKVStore(this.storeId, this.options, (err, store) => {
          if (err) {
            callback(false);
            return;
          }
          this.kvStorage = store as distributedKVStore.SingleKVStore;
          callback(true);
        });
      }
  }

  getData<T>(key: string): Promise<T> {
    return new Promise((resolve: Function, reject: Function) => {
      this.createKVStore((isSuccess) => {
        if (this.kvStorage) {
          this.kvStorage.get(key).then((value: string) => {
            let json = JSON.parse(value);
            resolve(json);
          }).catch((e) => {
            console.error(`获取 value 失败. Code: ${e.code}, message: ${e.message}`)
            reject(e);
          });
        }
      })
    });
  }

  putData(key: string, value: string): Promise<void> {
    return new Promise((resolve: Function, reject: Function) => {
      this.createKVStore((isSuccess) => {
        if (this.kvStorage) {
          this.kvStorage.put(key, value);
          resolve();
        } else {
          reject(new Error("kvStorage 不存在"));
        }
      });
    });
  }

  closeStore(): Promise<void> {
    if (this.kvManager) {
      return this.kvManager.closeKVStore(this.config.bundleName, this.storeId);
    }

    return new Promise((reject: Function) => {
      reject(new Error("关闭 kvStorage 失败"));
    });
  }

  deleteStore(): Promise<void> {
    if (this.kvManager) {
      return this.kvManager.deleteKVStore(this.config.bundleName, this.storeId);
    }

    return new Promise((reject: Function) => {
      reject(new Error("删除 kvStorage 失败"));
    });
  }
}