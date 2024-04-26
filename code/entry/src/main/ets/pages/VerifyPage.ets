
import Constants from '../common/constants/Constants'
import WindowManager from '../common/utils/WindowManager';
import VerifyItem from '../viewmodel/VerifyItem'

@Entry
@Component
struct VerifyPage {
  @State verifyItem: VerifyItem = new VerifyItem($r('app.media.ic_verity_character1'), 'XYZK');
  private verifyMap: Map<number, VerifyItem> = new Map();
  @State inputText: string = '';
  private imageId: number = 0;
  @State isInputWrong: boolean = false;

  aboutToAppear() {
    this.verifyMap = VerifyItem.getVerifyMap();
    this.updateVerifyItem();
  }

  updateVerifyItem() {
    let verifyItemNew: VerifyItem | undefined = this.verifyMap.get(this.imageId);
    if (verifyItemNew !== undefined) {
      this.verifyItem = verifyItemNew;
    }
  }

  build() {
    Column() {
      Column(){
        Row() {
          Image(this.verifyItem.image)
            .height('48vp')
            .width('164vp')
          Text('换一张')
            .fontColor($r('app.color.blue'))
            .fontSize(16)
            .width('80vp')
            .textAlign(TextAlign.Center)
            .onClick(() => {
              // 只有两张图
              this.imageId = (this.imageId + 1) % 2;
              this.updateVerifyItem();
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding('24vp')

        TextInput({ placeholder: '请输入验证码', text: this.inputText })
          .placeholderColor($r('app.color.placeholder_color'))
          .margin('10vp')
          .onChange((value: string) => {
            this.inputText = value;
          })
        if (this.isInputWrong) {
          Text('验证码错误，请重新输')
            .fontColor($r('app.color.verify_wrong_hints_color'))
            .promptTextStyle()
        } else {
          Text('为了保护你的网络安全，请输入验证码')
            .fontColor($r('app.color.placeholder_color'))
            .promptTextStyle()
        }

        Text('确定')
          .fontColor($r('app.color.login_blue_text_color'))
          .onClick(() => {
            let verifyText: string = this.verifyItem.characters;
            if (this.inputText.toLowerCase() === verifyText.toLowerCase()) {
              AlertDialog.show({
                message: `登录成功`,
                confirm: {
                  value: '确定',
                  action: () => {
                    // 销毁窗口
                    WindowManager.getInstance().destroySubWindow();
                    // 发送消息
                    getContext(this).eventHub.emit(Constants.STARTMAINPAGE);
                  }
                },
                cancel: () => {

                }
              })
            } else {
              this.isInputWrong = true;
              this.inputText = '';
              this.imageId = (this.imageId + 1) % 2;
              this.updateVerifyItem();
            }
          })
          .margin({ top: '40vp', bottom: '40vp' })
      }
      .backgroundColor(Color.White)
      .borderRadius('20vp')
    }
    .padding('12vp')
    .parentSize()
  }
}

@Styles function parentSize() {
  .width(Constants.FULL_PERCENT)
  .height(Constants.FULL_PERCENT)
}

@Extend(Text)
function promptTextStyle() {
  .fontSize('14')
  .width(Constants.FULL_PERCENT)
  .padding({
    left: '24vp',
    right: '24vp'
  })
}
