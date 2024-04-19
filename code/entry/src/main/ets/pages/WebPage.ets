import Constants from '../common/constants/Constants';

/*
* 一个讨论： @Extend 和 @Styles 如何导出供其他文件使用?
* 如果不能导出 那为何叫全局样式, 这是什么设计?
 */

/*
 * 默认样式按钮
 * top: marginTop值
 * */
@Extend(Button) function defaultButton(top: string) {
  .fontSize(Constants.MainConstant_BUTTON_FONT_SIZE)
  .fontColor($r('app.color.start_window_background'))
  .width(Constants.MainConstant_BUTTON_WIDTH)
  .height(Constants.MainConstant_BUTTON_HEIGHT)
  .margin({ top: top })
  .backgroundColor($r('app.color.blue'))
  .borderRadius(Constants.MainConstant_BUTTON_BORDER_RADIUS)
}

@Styles function parentSize() {
  .width(Constants.FULL_PERCENT)
  .height(Constants.FULL_PERCENT)
}

let WebDetailPagePath = "pages/WebDetailPage";



@Component
export default struct WebPage {
  @Builder NavigationMenus() {
    Row() {
      Text('菜单1')
      Blank()
      Text('菜单2')
    }
  }

  build() {

    Navigation() {
      Column() {
        Navigator({ target: WebDetailPagePath, type: NavigationType.Push }) {
          Button("本地 Html")
            .defaultButton(Constants.MainConstant_BUTTON_MARGIN_TOP)
        }
        .params({ path: $rawfile('index.html'), title: "本地" })

        Navigator({ target: WebDetailPagePath, type: NavigationType.Push }) {
          Button("远端 Html")
            .defaultButton(Constants.MainConstant_BUTTON_MARGIN_TOP)
        }
        .params({ path: "www.baidu.com", title: "云端" })
      }
      .backgroundColor($r('app.color.white'))
      .parentSize()
      .justifyContent(FlexAlign.Center)
    }
    .mode(NavigationMode.Auto)
    .title("Web")
    .hideBackButton(true)
    .titleMode(NavigationTitleMode.Mini)
    .menus(this.NavigationMenus())
    .parentSize()

  }
}