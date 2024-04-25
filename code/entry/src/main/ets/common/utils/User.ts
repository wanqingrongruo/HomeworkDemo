import PreferencesManager from './PreferencesManager'
import common from '@ohos.app.ability.common';

export class User {
  name: string
}

export class UserCacheManager {
  context: common.Context
  private manager: PreferencesManager

  constructor(context: common.Context) {
    this.context = context
    this.manager = new PreferencesManager(context, "user")
  }

  save(user: User): Promise<void> {
    return this.manager.putData("userinfo", JSON.stringify(user))
  }

  get(): Promise<User> {
    return new Promise((resolve: Function, reject: Function) => {
      this.manager.getData("userinfo", "").then((value) => {
        if (value.length == 0) {
          reject(new Error("no user exist"));
        } else {
          let user = JSON.parse(value) as User;
          resolve(user);
        }
      }).catch((e) => {
        reject(e);
      })
    });
  }
}