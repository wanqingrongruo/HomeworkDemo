import router from '@ohos.router';
import display from '@ohos.display';
import Constants from '../common/constants/Constants'
import WindowManager, { WindowRect } from '../common/utils/WindowManager';
import { User, UserCacheManager } from '../common/utils/User';

@Entry
@Component
struct LoginPage {
  @State account: string = '';
  @State password: string = '';
  @State isShadow: boolean = false;

  displayVerifyCode() {
    let screen = display.getDefaultDisplaySync();
    let windowWidth = screen.width * 0.9;
    // w:h = 1.2
    let windowHeight = windowWidth / 1.2;
    let rect = WindowRect.createWithContainer(screen.width, screen.height, windowWidth, windowHeight);
    WindowManager.getInstance().createSubWindow(rect, 'pages/VerifyPage', '#FF0000')
  }

  isLoginClickable(account: string, psd: string): boolean {
    return account !== '' && psd !== '';
  }

  aboutToAppear() {
    // 监听 event hud 推送
    getContext(this).eventHub.on(Constants.STARTMAINPAGE, () => {
      // 缓存用户数据
      let user = new User(this.account);
      let cacheManager = new UserCacheManager(getContext(this));
      cacheManager.save(user);
      // 还原导航和状态栏
      WindowManager.getInstance().setMainWindowNormal();
      // 刷新到主页
      router.replaceUrl({
        url: "pages/MainPage"
      }).catch((err: Error) => {
        // error handle
      });
    });
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Column() {
        Column() {
          Image($r('app.media.icon'))
            .width(50)
            .height(50)
            .borderRadius(8)
          Text('登录界面')
            .fontColor(Color.Black)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 10 })
          Text('不登录就不给你玩')
            .fontColor(Color.Gray)
            .fontSize(14)
            .margin({ top: 10, bottom: 24 })
        }.margin({ top: 100 })
        .alignItems(HorizontalAlign.Center)

        Column() {
          TextInput({ placeholder: '账号' })
            .width('100%')
            .height(44)
            .padding({ left: 8, right: 8 })
            .placeholderColor(Color.Grey)
            .inputStyle()
            .onChange((value: string) => {
              this.account = value;
            })

          Divider()
            .width('100%')
            .height('0.5vp')
            .padding({ left: 8, right: 8 })
            .color($r('app.color.line_color'))

          TextInput({ placeholder: '密码' })
            .width('100%')
            .height(44)
            .padding({ left: 8, right: 8 })
            .placeholderColor(Color.Grey)
            .type(InputType.Password)
            .inputStyle()
            .onChange((value: string) => {
              this.password = value;
            })
        }
        .width('90%')
        .backgroundColor(Color.White)
        .borderRadius(12)

        Button("登录")
          .defaultButton(Constants.MainConstant_BUTTON_MARGIN_TOP)
          .backgroundColor(this.isLoginClickable(this.account, this.password) ? $r('app.color.login_button_color') : $r('app.color.login_button_disable'))
          .fontColor(this.isLoginClickable(this.account, this.password) ? Color.White : $r('app.color.login_font_disable'))
          .enabled(this.isLoginClickable(this.account, this.password))
          .onClick(() => {
            this.isShadow = true;
            this.displayVerifyCode()
          });
      }
      .parentSize()
      .backgroundColor($r('app.color.background'))

      if (this.isShadow) {
        Rect()
          .parentSize()
          .fillOpacity(0.2)
          .fill($r('app.color.title_text_color'))
      }
    }
  }
}

@Styles function parentSize() {
  .width(Constants.FULL_PERCENT)
  .height(Constants.FULL_PERCENT)
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

@Extend(TextInput) function inputStyle() {
  .placeholderColor($r('app.color.placeholder_color'))
  .backgroundColor(($r('app.color.start_window_background')))
}