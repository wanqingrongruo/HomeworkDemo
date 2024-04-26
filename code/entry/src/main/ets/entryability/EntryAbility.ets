import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import { UserCacheManager } from '../common/utils/User';
import WindowManager from '../common/utils/WindowManager';

export default class EntryAbility extends UIAbility {
  userManager: UserCacheManager

  onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    this.userManager = new UserCacheManager(this.context);
    let windowManager = WindowManager.getInstance();
    windowManager.setWindowStage(windowStage);

    // 已登录打开主页, 没有登录显示登录页面
    this.userManager.get().then((value) => {
      this.loadContent(windowStage, "pages/MainPage");
    }).catch((err) => {
      windowManager.setMainWindowImmersive();
      this.loadContent(windowStage, "pages/LoginPage");
    });
  }

  private loadContent(windowStage: window.WindowStage, page: string) {
    windowStage.loadContent(page, (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
