import router from '@ohos.router';
import Constants from '../common/constants/Constants';
import PreferencesManager from '../common/utils/PreferencesManager';
import { UserCacheManager } from '../common/utils/User';
import WindowManager from '../common/utils/WindowManager';

@Component
export default struct MinePage {
  userManager: UserCacheManager = new UserCacheManager(getContext(this));
  @State userName: string = "";

  aboutToAppear() {
    this.userManager.get().then((value) => {
      this.userName = value.name;
    }).catch((err) => {
       this.userName = ""
    })
  }


  build() {
    Column() {
      Text(this.userName === '' ? '未登录' : this.userName)
        .width(Constants.FULL_PERCENT)
        .textAlign(TextAlign.Center)
        .fontSize('40vp')

      Button("退出登录")
        .defaultButton(Constants.MainConstant_BUTTON_MARGIN_TOP)
        .visibility(this.userName === '' ? Visibility.None : Visibility.Visible)
        .onClick(() => {
            this.userManager.clear().then((value) => {
              if(value) {
                // 清除 tab index 的缓存
                let preferencesManager: PreferencesManager = new PreferencesManager(getContext(this), "TabHistoryCurrentIndex");
                preferencesManager.delete("tabCurrentIndexKey")

                WindowManager.getInstance().setMainWindowImmersive();
                // 切换到登录页
                router.replaceUrl({
                  url: "pages/LoginPage"
                }).catch((err: Error) => {
                  // error handle
                });
              }
            })
        });
    }
    .backgroundColor($r('app.color.white'))
    .height(Constants.FULL_PERCENT)
    .width(Constants.FULL_PERCENT)
  }
}

@Extend(Button) function defaultButton(top: string) {
  .fontSize(Constants.MainConstant_BUTTON_FONT_SIZE)
  .fontColor($r('app.color.start_window_background'))
  .width(Constants.MainConstant_BUTTON_WIDTH)
  .height(Constants.MainConstant_BUTTON_HEIGHT)
  .margin({ top: top })
  .backgroundColor($r('app.color.blue'))
  .borderRadius(Constants.MainConstant_BUTTON_BORDER_RADIUS)
}