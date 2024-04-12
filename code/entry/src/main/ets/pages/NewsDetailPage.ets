import router from '@ohos.router'
import window from '@ohos.window'
import Constants from '../common/constants/Constants'
import { ListData } from '../network/NewsResult'

@Entry
@Component
struct NewsDetailPage {
  item: ListData = router.getParams()['item']
  private swiperController: SwiperController = new SwiperController()
  private data: MyDataSource = new MyDataSource([])
  @State statusHeight: number = 0

  isEmptyOrNull(str: string): Boolean {
    if (str) {
      if (str.length == 0) {
        return true;
      }
      return false;
    }

    return true;
  }

  getImages(): string[] {
    let images: string[] = []
    if (this.item) {
      if (!this.isEmptyOrNull(this.item.thumbnail_pic_s)) {
        images.push(this.item.thumbnail_pic_s);
      }
      if (!this.isEmptyOrNull(this.item.thumbnail_pic_s02)) {
        images.push(this.item.thumbnail_pic_s02);
      }
      if (!this.isEmptyOrNull(this.item.thumbnail_pic_s03)) {
        images.push(this.item.thumbnail_pic_s03);
      }
    }

    this.data = new MyDataSource(images);
    return images;
  }

  onPageShow() {
    window.getLastWindow(getContext(this), (err, w) => {
      if (w) {
        w.setWindowLayoutFullScreen(true);
        w.setWindowSystemBarEnable([])
        this.statusHeight = w.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height
      }
    })
  }

  onPageHide() {
    window.getLastWindow(getContext(this), (err, window) => {
      if (window) {
        window.setWindowLayoutFullScreen(false);
        window.setWindowSystemBarEnable(['status', 'navigation'])
      }
    })
  }

  build() {
    Row() {
      RelativeContainer() {
        Column() {
          Row() {
            Text(this.item.title)
              .fontColor($r('app.color.title_color'))
              .fontSize($r('app.float.title_font'))
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .layoutWeight(1)
            Text(this.item.author_name)
              .fontColor($r('app.color.red'))
              .fontSize($r('app.float.desc_font'))
              .maxLines(1)
              .margin({ left: 20 })
              .alignSelf(ItemAlign.Start)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .width(Constants.FULL_PERCENT)
          .padding({ top: 8, left: 8, right: 8, bottom: 0 })

          if (this.getImages().length > 0) {
            Swiper(this.swiperController) {
              LazyForEach(this.data, (item: string) => {
                Image(item)
                  .objectFit(ImageFit.Contain)
                  .height(200)
              }, item => item)
            }
            .cachedCount(1)
            .index(0)
            .autoPlay(true)
            .interval(4000)
            .indicator(true)
            .loop(true)
            .duration(1000)
            .itemSpace(0)
            .curve(Curve.Linear)
            .onChange((index: number) => {
              console.info(index.toString())
            })
            .margin({ top: 40, bottom: 40 })
          }

          Row() {
            Text(this.item.date)
              .fontColor($r('app.color.tab_normal_color'))
              .fontSize($r('app.float.desc_font'))
          }
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Center)
          .height(30)
          .width(Constants.FULL_PERCENT)
          .padding({ top: 0, left: 8, right: 8, bottom: 0 })
          .alignSelf(ItemAlign.Start)
        }
        .justifyContent(FlexAlign.Start)
        .alignRules({
          top: { anchor: "__container__", align: VerticalAlign.Top }
        })
        .offset({
          y: this.statusHeight
        })
        .id("content1")

        Image($r('app.media.ic_back'))
          .backgroundColor($r('app.color.white'))
          .width(50)
          .height(50)
          .onClick(() => {
            router.back();
          })
          .alignRules({
            bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
            right: { anchor: "__container__", align: HorizontalAlign.End }
          })
          .offset({
            x: -50,
            y: -50
          })
          .id("image1")
      }
      .width(Constants.FULL_PERCENT)
      .height(Constants.FULL_PERCENT)
      .backgroundColor($r('app.color.dividerColor'))
    }
    .width(Constants.FULL_PERCENT)
    .height(Constants.FULL_PERCENT)
  }
}

class MyDataSource implements IDataSource {
  private list: string[] = []
  private listener: DataChangeListener

  constructor(list: string[]) {
    this.list = list
  }

  totalCount(): number {
    return this.list.length
  }

  getData(index: number): any {
    return this.list[index]
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    this.listener = listener
  }

  unregisterDataChangeListener() {
  }
}