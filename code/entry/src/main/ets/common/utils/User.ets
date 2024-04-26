import PreferencesManager from './PreferencesManager'

export class User {
  name: string

  constructor(name: string) {
    this.name = name;
  }
}

export class UserCacheManager {
  context: Context
  private manager: PreferencesManager

  constructor(context: Context) {
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

  clear(): Promise<boolean> {
    return this.manager.delete("userinfo");
  }
}