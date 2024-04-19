import router from '@ohos.router'
import webview from '@ohos.web.webview';
import prompt from '@ohos.prompt';
import Constants from '../common/constants/Constants';
import JSBridge from '../common/utils/JSBridge';

@Styles function parentSize() {
  .width(Constants.FULL_PERCENT)
  .height(Constants.FULL_PERCENT)
}

@Extend(Text) function defaultText(fontSize: number) {
  .fontSize(fontSize)
  .textAlign(TextAlign.Center)
  .fontColor($r('app.color.text_value_font_color'))
  .height(Constants.WebConstant_TEXT_VALUE_HEIGHT)
  .fontWeight(Constants.WebConstant_TEXT_VALUE_FONT_WEIGHT)
  .margin({ top: Constants.WebConstant_TEXT_VALUE_MARGIN_TOP })
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

class Toast {
  constructor() {
  }

  fly(obj: Object) {
    let msg = obj['msg']
    msg = msg == null ? 'roni' : msg;
    AlertDialog.show({
      message: `${msg} 直接原地起飞`,
      confirm: {
        value: '确定',
        action: () => {

        }
      },
      cancel: () => {

      }
    })
  }
}

@Entry
@Component
struct WebDetailPage {
  @State params: Object = router.getParams();
  webController: webview.WebviewController = new webview.WebviewController;
  @State progressVal: number = 0;
  @State isLoading: boolean = true;
  @State intervalLoadingId: number = -1;
  // 要注册的对象
  @State toast: Toast = new Toast();
  private jsBridge: JSBridge = new JSBridge(this.webController);

  aboutToAppear() {
    // 计时器
    this.intervalLoadingId = setInterval(() => {
      this.progressVal = this.progressVal >= 100 ? 0 : (this.progressVal + 10);
    }, 100);
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Image($r('app.media.background'))
        .parentSize()
      Column() {
        Row() {
          Image($r('app.media.ic_back'))
            .width(Constants.WebConstant_IMAGE_WIDTH)
            .height(Constants.WebConstant_IMAGE_HEIGHT)
            .margin({ left: Constants.WebConstant_IMAGE_MARGIN_LEFT })

          Text('返回')
            .fontSize(Constants.WebConstant_TOP_TEXT_FONT_SIZE)
            .width(Constants.WebConstant_TOP_TEXT_WIDTH)
            .height(Constants.WebConstant_TOP_TEXT_HEIGHT)
            .fontColor($r('app.color.black'))
            .margin({ left: Constants.WebConstant_TOP_TEXT_MARGIN_LEFT })
        }
        .height(Constants.WebConstant_TOP_ROW_HEIGHT)
        .onClick(() => {
          router.back();
        })

        Web({ src: this.params['path'], controller: this.webController })
          .zoomAccess(false)
          .width(Constants.WebConstant_WIDTH)
          .height(Constants.WebConstant_HEIGHT)
          .margin({ left: Constants.WebConstant_MARGIN_LEFT, right: Constants.WebConstant_MARGIN_RIGHT,
            top: Constants.WebConstant_MARGIN_TOP })
          .onConfirm((event) => {
            AlertDialog.show({
              message: 'hhhh' + event?.message,
              confirm: {
                value: '确定',
                action: () => {
                  event?.result.handleConfirm();
                }
              },
              cancel: () => {
                event?.result.handleCancel();
              }
            })

            return true;
          })
          .javaScriptAccess(true)
          .javaScriptProxy(this.jsBridge.javaScriptProxy)
          .onPageBegin(() => {
            this.jsBridge.initJsBridge();
          })
          .onErrorReceive((event) => {
            if (event?.error.getErrorInfo() === 'ERR_INTERNET_DISCONNECTED') {
              prompt.showToast({
                message: '网络错误',
                duration: 3000
              })
            }
            if (event?.error.getErrorInfo() === 'ERR_CONNECTION_TIMED_OUT') {
              prompt.showToast({
                message: '网络错误',
                duration: 3000
              })
            }
          })
          .onProgressChange((event) => {
            if (event?.newProgress === 100) {
              this.isLoading = false;
              clearInterval(this.intervalLoadingId);
              this.intervalLoadingId = -1;
            }
          })

        Column() {
          Text('web组件')
            .defaultText(Constants.WebConstant_TEXT_VALUE_FONT_SIZE)
          Text(this.params['title'])
            .defaultText(Constants.WebConstant_TIP_TEXT_VALUE_FONT_SIZE)
        }

        if (this.params['title'] == "本地") {
          Button("点击开始抽奖")
            .defaultButton('10%')
            .onClick(() => {
              this.webController.runJavaScript('startDraw()');
            })
        }
      }
      .parentSize()

      if (this.isLoading) {
        Progress({
          value: Constants.WebConstant_PROGRESS_MIN,
          total: Constants.WebConstant_PROGRESS_MAX,
          type: ProgressType.ScaleRing
        })
          .color(Color.Grey)
          .value(this.progressVal)
          .width(Constants.WebConstant_PROGRESS_WIDTH)
          .style({
            strokeWidth: Constants.WebConstant_PROGRESS_STROKE_WIDTH,
            scaleCount: Constants.WebConstant_PROGRESS_SCALE_COUNT,
            scaleWidth: Constants.WebConstant_PROGRESS_SCALE_WIDTH
          })
          .zIndex(1)
          .position({
            x: Constants.WebConstant_PROGRESS_POSITION_X,
            y: Constants.WebConstant_PROGRESS_POSITION_Y
          })
      }
    }
  }
}

function fontSize(MainConstant_BUTTON_FONT_SIZE: number) {
  throw new Error('Function not implemented.');
}
